require 'thor/group'
require 'active_support/inflector'
require 'json'

module Turbine
  class GenerateCommand < Thor::Group
    include Thor::Actions

    desc "Creates a new simple turbine command"
    argument :name
    argument :path

    def self.source_root
      File.dirname(__FILE__)
    end

    def create_command_file
      template('templates/generate_command/command.rb.erb', "#{path}/#{name}.rb")
    end

    def print_info
      say_status(:info, "Don't forget to add the command fragment to your turbine.json")

      command_info = Hash.new
      command_info[:name] = name
      command_info[:usage] = "#{name} <arg1> <arg2> ..."
      command_info[:description] = "Add description here"
      command_info[:class] = "Turbine::#{name.camelize}"
      command_info[:path] = "./#{name}.rb"

      puts JSON.pretty_generate(command_info, indent: '  ', space: ' ')
    end

  end
end
