#
# Cookbook Name:: docker
# Recipe:: default
#
# Copyright 2015, Travis CI GmbH
#
# MIT License
#

include_recipe 'apt'
include_recipe 'travis_build_environment'

apt_repository 'docker' do
  uri 'https://apt.dockerproject.org/repo'
  distribution 'ubuntu-trusty'
  components ['main']
  key 'https://apt.dockerproject.org/gpg'
  action :add
end

package %W(
  linux-image-extra-#{`uname -r`.chomp}
  linux-generic-lts-vivid
  lxc
)

package 'docker-engine' do
  version node['docker']['version']
end

group 'docker' do
  members node['docker']['users']
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
