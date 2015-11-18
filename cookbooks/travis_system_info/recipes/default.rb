#
# Cookbook Name:: travis_system_info
# Recipe:: default
#
# Copyright 2015, Travis CI GmbH
#
# MIT License
#

local_gem = "#{Chef::Config[:file_cache_path]}/system-info.gem"

remote_file local_gem do
  source node['travis_system_info']['gem_url']
  checksum node['travis_system_info']['gem_sha256sum']
end

gem_package 'system-info' do
  gem_binary '/opt/chef/embedded/bin/gem'
  source local_gem
end

execute "rm -rf #{node['travis_system_info']['dest_dir']}"

directory node['travis_system_info']['dest_dir'] do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  recursive true
end

execute system_info_command(
  user: node['travis_build_environment']['user'],
  dest_dir: node['travis_system_info']['dest_dir'],
  commands_file: node['travis_system_info']['commands_file'],
  cookbooks_sha: node['travis_system_info']['cookbooks_sha']
)
