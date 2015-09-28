#
# Cookbook Name:: docker
# Recipe:: default
#
# Copyright 2015, Travis CI GmbH
#
# MIT License
#

include_recipe 'apt'
include_recipe 'travis_docker::package'

group 'docker' do
  members node['travis_docker']['users']
  action [:create, :manage]
end

cookbook_file '/etc/default/docker' do
  source 'etc/default/docker'
  owner 'root'
  group 'root'
  mode 0640
end

cookbook_file '/etc/default/grub.d/99-travis-settings.cfg' do
  source 'etc/default/grub.d/99-travis-settings.cfg'
  owner 'root'
  group 'root'
  mode 0640
end

execute 'update-grub'
