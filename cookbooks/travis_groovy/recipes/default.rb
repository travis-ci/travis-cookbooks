# frozen_string_literal: true

# Cookbook Name:: travis_groovy
# Recipe:: default
#
# Copyright 2017 Travis CI GmbH

ark 'groovy' do
  url node['travis_groovy']['url']
  version node['travis_groovy']['version']
  checksum node['travis_groovy']['checksum']
  path node['travis_groovy']['installation_dir']
  has_binaries %w[
    grape
    groovy
    groovyc
    groovyConsole
    groovydoc
    groovysh
    java2groovy
    startGroovy
  ].map { |exe| "bin/#{exe}" }
  owner 'root'
end
