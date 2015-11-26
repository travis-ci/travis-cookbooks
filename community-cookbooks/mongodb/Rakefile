#!/usr/bin/env rake

require 'rake'
require 'rake/tasklib'
require 'rake/testtask'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = 'test/unit'
end

require 'rubocop/rake_task'
desc 'Run RuboCop to check style'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['**/*.rb']
  # only show the files with failures
  #task.formatters = ['files']
  # don't abort rake on failure
  task.fail_on_error = false
  task.options = ['-D']
end

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  warn 'Could not load kitchen rake tasks, skipping'
end

# aliases
task :test => :spec
task :lint => [:rubocop]
task :default => [:lint, :test]
task :all => [:test, 'kitchen:all']
