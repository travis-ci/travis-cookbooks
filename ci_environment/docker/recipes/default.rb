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
  owner 'root'
  group 'root'
  mode 0640

  source 'etc/default/docker'
end

ruby_block 'Enable cgroup memory and swap accounting' do
  block do
    fe = Chef::Util::FileEdit.new('/etc/default/grub')
    fe.search_file_replace_line(
      /^GRUB_CMDLINE_LINUX=""/,
      'GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1 apparmor=0"'
    )
    fe.write_file
  end
end

execute 'update-grub'
