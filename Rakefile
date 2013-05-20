#!/usr/bin/env rake

require 'foodcritic'

task :default => [:foodcritic]

FoodCritic::Rake::LintTask.new do |t|
  t.files = [ 'ci_environment', 'worker_host' ]
  t.options = {
    :fail_tags => %w( ~FC002 ~FC003 ~FC004 ~FC005 ~FC007 ~FC011 ~FC012 ~FC013 ~FC014 ~FC015 ~FC016 ~FC017 ~FC019 ~FC023 ~FC024 ~FC031 ~FC033 ~FC042 ~FC043 ~FC045 )
  }
end

