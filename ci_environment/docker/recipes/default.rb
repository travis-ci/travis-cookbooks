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
  uri 'https://get.docker.io/ubuntu'
  distribution 'docker'
  components ['main']
  key 'https://get.docker.io/gpg'
  action :add
end

docker_pkg = 'lxc-docker'
docker_pkg += "-#{node['docker']['version']}" if node['docker']['version']

package %W(linux-image-extra-#{`uname -r`.chomp} lxc #{docker_pkg})

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
