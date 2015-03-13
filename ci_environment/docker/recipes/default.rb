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
  uri "https://get.docker.io/ubuntu"
  distribution "docker"
  components ["main"]
  key "https://get.docker.io/gpg"
  action :add
end

package "linux-image-extra-#{`uname -r`.chomp}" do
  action :install
end

package "lxc" do
  action :install
end

pkg = 'lxc-docker'
pkg += "-#{node['docker']['version']}" if node['docker']['version']
package pkg do
  action :install
end

group 'docker' do
  members node['docker']['users']
  action [:create, :manage]
end

cookbook_file '/etc/default/docker' do
  owner 'root'
  group 'root'
  mode 0640

  source 'etc/default/docker'
end

execute "Update Grub config" do
  command "sed -i 's/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"cgroup_enable=memory swapaccount=1\"/' /etc/default/grub && update-grub"
end
