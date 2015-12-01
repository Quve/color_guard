$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "color_guard/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "color_guard"
  s.version     = ColorGuard::VERSION
  s.authors     = ["Ryan Burrows"]
  s.email       = ["ryan@mazlo.me"]
  s.homepage    = "https://github.com/Quve/color_guard'"
  s.summary     = "Feature flags and more!"
  s.description = "ColorGuard is a library providing feature flags to rails applications"

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2"
  s.add_dependency "rollout", "~> 2.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "cane"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "simplecov"
end
