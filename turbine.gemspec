Gem::Specification.new do |s|
  s.name               = "turbine"
  s.version            = "0.0.1"
  s.executables       << "turbine"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sean Harmer"]
  s.license = "MIT"
  s.date = %q{2023-07-25}
  s.description = %q{A generic generator and tasks gem to avoid developer copy pasta}
  s.email = %q{sean.harmer@kdab.com}
  s.files = ["lib/turbine.rb", "lib/turbine/meta.rb", "lib/turbine/utils.rb", "bin/turbine"]
  s.test_files = []
  s.homepage = %q{http://rubygems.org/gems/turbine}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Create tasks similar to Rails generators to help you with your common tasks but without needing rails.}
  s.add_runtime_dependency "thor", "~> 1.2", ">=1.2.2"
  s.add_runtime_dependency "activesupport", "~> 7.1", ">=7.1.2"

  if s.respond_to? :specification_version then
    s.specification_version = 3
  else
  end
end
