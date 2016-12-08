#!/usr/bin/env rake
require 'foodcritic'

FoodCritic::Rake::LintTask.new do |t|
  t.files = %w(
    ci_environment
    worker_host
  )
  t.options = {
    tags: %w(
      ~FC001
      ~FC002
      ~FC003
      ~FC004
      ~FC005
      ~FC007
      ~FC009
      ~FC010
      ~FC013
      ~FC015
      ~FC016
      ~FC017
      ~FC019
      ~FC022
      ~FC023
      ~FC024
      ~FC043
      ~FC047
      ~FC048
      ~FC053
      ~FC055
      ~FC056
      ~FC059
      ~FC062
      ~FC064
      ~FC065
      ~readme
    ),
    chef_version: '12.9',
    progress: true
  }
end

task default: :foodcritic
