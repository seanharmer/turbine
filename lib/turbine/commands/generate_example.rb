require 'thor/group'

module Turbine
  class GenerateExample < Thor::Group
    include Thor::Actions

    desc "Creates a new example application"
    argument :name

    def self.source_root
      File.dirname(__FILE__)
    end

    def create_main_cpp_file
      template('templates/generate_example/main.cpp.erb', "examples/#{name}/main.cpp")
    end

    def create_class_h_file
      template('templates/generate_example/class.h.erb', "examples/#{name}/#{name}.h")
    end

    def create_class_cpp_file
      template('templates/generate_example/class.cpp.erb', "examples/#{name}/#{name}.cpp")
    end

    def create_cmakelists_file
      template('templates/generate_example/CMakeLists.txt.erb', "examples/#{name}/CMakeLists.txt")
    end

    def add_to_examples_cmakelists
      if ::File.exist?("examples/CMakeLists.txt")
        insert_into_file("examples/CMakeLists.txt", "add_subdirectory(#{name})\n", after: "# turbine: Examples\n")
      else
        say_status(:unchanged, "Did not add to parent CMakeLists.txt as file not present", :blue)
      end
    end

  end
end
