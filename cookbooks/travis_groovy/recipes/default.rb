# Cookbook Name:: travis_groovy
# Recipe:: default
#
# Copyright 2015, Travis CI GmbH

ark 'groovy' do
  url node['travis_groovy']['url']
  version node['travis_groovy']['version']
  checksum node['travis_groovy']['checksum']
  path node['travis_groovy']['installation_dir']
  owner 'root'
end
