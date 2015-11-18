#
# Cookbook Name:: travis_system_info
# Recipe:: default
#
# Copyright 2015, Travis CI GmbH
#
# MIT License
#

chef_gem 'travis-system-info' do
  source node['travis_system_info']['gem_url']
  compile_time true
end

git node['travis_system_info']['install_dir'] do
  repository node['travis_system_info']['git_repo']
  revision node['travis_system_info']['git_ref']
  action :sync
end

execute "set owner on #{node['travis_system_info']['install_dir']}" do
  command "chown -R #{node['travis_build_environment']['user']}:#{node['travis_build_environment']['group']} #{node['travis_system_info']['install_dir']}"
end

execute "remove #{node['travis_system_info']['dest_dir']}" do
  command "rm -rf #{node['travis_system_info']['dest_dir']}"
end

directory node['travis_system_info']['dest_dir'] do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  recursive true
end

run_system_info(
  user: node['travis_build_environment']['user'],
  dest_dir: node['travis_system_info']['dest_dir'],
  commands_file: node['travis_system_info']['commands_file'],
  cookbooks_sha: node['travis_system_info']['cookbooks_sha']
)
