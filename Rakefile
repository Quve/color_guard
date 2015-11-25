begin
  require 'bundler/setup'
  require "rspec/core"
  require "rspec/core/rake_task"
  require "cane/rake_task"

rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
  exit 1
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'
load 'rails/tasks/statistics.rake'

Bundler::GemHelper.install_tasks

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(spec: "app:db:test:prepare")

desc "Run can to check quality metrics"
Cane::RakeTask.new(:quality)

task default: [:spec, :quality]
