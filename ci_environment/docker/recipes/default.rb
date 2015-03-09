#
# Cookbook Name:: docker
# Recipe:: default
#
# Copyright 2015, Travis CI GmbH
#
# MIT License
#

package 'apt-transport-https' do
  action :install
end

apt_repository 'docker.io' do
  uri 'https://get.docker.com/ubuntu'
  distribution node['lsb']['codename']
  components   ["main"]
  key "36A1D7869245C8950F966E92D8576A8BA88D21E9"
  keyserver "keyserver.ubuntu.com"

  action :add
end

package 'lxc-docker'
