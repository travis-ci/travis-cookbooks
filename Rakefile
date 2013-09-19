#!/usr/bin/env rake

require 'foodcritic'

task :default => [:foodcritic]

FoodCritic::Rake::LintTask.new do |t|
  t.files = [ 'ci_environment', 'worker_host' ]
  t.options = {
    :tags => %w( ~readme ),
    :fail_tags => %w( ~FC002 ~FC003 ~FC004 ~FC005 ~FC013 ~FC015 ~FC016 ~FC017 ~FC019 ~FC023 ~FC024 ~FC043 )
  }
end

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
end

