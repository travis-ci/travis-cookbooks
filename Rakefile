#!/usr/bin/env rake

require 'foodcritic'
require 'rspec/core/rake_task'
require 'strainer/rake_task'

task :default => [:foodcritic, :spec]

FoodCritic::Rake::LintTask.new do |t|
  t.files = [ 'ci_environment', 'worker_host' ]
  t.options = {
    :tags => %w( ~readme ),
    :fail_tags => %w( ~FC002 ~FC003 ~FC004 ~FC005 ~FC013 ~FC015 ~FC016 ~FC017 ~FC019 ~FC023 ~FC024 ~FC043 )
  }
end

RSpec::Core::RakeTask.new

# Strainer::RakeTask.new(:strainer) do |s|
#  s.strainer_file = 'Strainerfile'
# end
task :strainer, :cookbook do |task, args|
  system "bundle exec strainer test #{args[:cookbook]}"
end
task :strainer => :fool_strainer

task :superstrainer => :fool_strainer do
  Dir['cookbooks/*'].each do |cookbook|
    cookbook = File.basename cookbook
    puts "Straining #{cookbook}"
    Rake::Task['strainer'].execute :cookbook => cookbook
  end
end

task :fool_strainer do
  # make it think we're a chef repo, even though this project is non-standard
  FileUtils.mkdir_p '.chef'
  FileUtils.mkdir_p 'environments'
  FileUtils.mkdir_p 'cookbooks'
  FileUtils.cp_r Dir['worker_host/*'], 'cookbooks'
  FileUtils.cp_r Dir['ci_environment/*'], 'cookbooks'
end
