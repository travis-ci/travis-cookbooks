#!/usr/bin/env rake

require 'foodcritic'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:unit) do |t|
  t.pattern = "test/unit/**/*_spec.rb"
end

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
end

task :default => [:foodcritic, :unit]
FoodCritic::Rake::LintTask.new
