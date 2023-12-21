require 'json'
require 'pathname'
require 'thor'
require 'pp'

require_relative './turbine/utils'

class ::Hash
  def deep_merge(second)
    merger = proc { |_, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : Array === v1 && Array === v2 ? v1 | v2 : [:undefined, nil, :nil].include?(v2) ? v1 : v2 }
    merge(second.to_h, &merger)
  end
end

def expand_command_paths(options, path)
  options[:commands].each do |command|
    command[:absolute_path] = path.join(command[:path]).to_s
  end
  # pp options
  return options
end

def get_options
  # Look up project specific options from pwd/.turbine/turbine.json
  project_options = Hash.new
  project_path = Pathname.new(Dir.pwd).join(".turbine")
  project_config_file_path = project_path.join("turbine.json")
  if project_config_file_path.exist?
    project_config = project_config_file_path.read
    project_options = expand_command_paths(JSON.parse(project_config, { symbolize_names: true }), project_path)
  end
  # pp project_options

  # Look up user specific commands at $TURBINE_LOCAL_PATH
  user_options = Hash.new
  if ENV.include?("TURBINE_LOCAL_PATH")
    user_path = Pathname.new(ENV["TURBINE_LOCAL_PATH"])
    user_config_file_path = user_path.join("turbine.json")
    if user_config_file_path.exist?
      user_config = user_config_file_path.read
      user_options = expand_command_paths(JSON.parse(user_config, { symbolize_names: true }), user_path)
    end
  end
  # pp user_options

  # Look up installation specific commands
  turbine_options = Hash.new
  root_path = Pathname.new(Turbine::Utils::gem_libdir)
  root_config_file_path = root_path.join("turbine.json")
  # puts "root_config_file_path = #{root_config_file_path}"
  if root_config_file_path.exist?
    root_config = root_config_file_path.read
    turbine_options = expand_command_paths(JSON.parse(root_config, { symbolize_names: true }), root_path)
  end
  # pp turbine_options

  # Cascade the options such that project > user > root.
  turbine_options = turbine_options.deep_merge(user_options)
  turbine_options = turbine_options.deep_merge(project_options)
  # pp turbine_options
  return turbine_options
end

options = get_options

# puts "Turbine::Utils::gem_libdir = #{Turbine::Utils::gem_libdir}"

# require the files needed by commands
$commands = options[:commands]
if !$commands.nil?
  $commands.each do |command|
    # puts "require #{command[:absolute_path]}"
    require command[:absolute_path]
  end
end

class TurbineApp < Thor
  # Register any commands specified in the options cascade
  if !$commands.nil?
    $commands.each do |command|
      # puts "Reigstering command #{command[:name]}"

      # Convert class string to a class constant symbol
      klass = command[:class].split('::').reduce(Module, :const_get)

      register(
        klass,
        command[:name],
        command[:usage],
        command[:description]
      )
    end
  end

  def self.exit_on_failure?
    true
  end
end
