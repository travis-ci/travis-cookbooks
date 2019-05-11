# frozen_string_literal: true

# Cookbook Name:: travis_system_info
# Recipe:: default
#
# Copyright 2017 Travis CI GmbH
#
# MIT License
#

local_gem = "#{Chef::Config[:file_cache_path]}/system-info.gem"

remote_file local_gem do
  source node['travis_system_info']['gem_url']
  checksum node['travis_system_info']['gem_sha256sum']
end

execute "/opt/chef/embedded/bin/gem install -b #{local_gem.inspect}"

execute "rm -rf #{node['travis_system_info']['dest_dir']}"

directory node['travis_system_info']['dest_dir'] do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  recursive true
end

ruby_block 'generate system-info report' do
  block do
    exec = Chef::Resource::Execute.new('system-info report', run_context)
    exec.command(
      SystemInfoMethods.system_info_command(
        user: node['travis_build_environment']['user'],
        dest_dir: node['travis_system_info']['dest_dir'],
        commands_file: node['travis_system_info']['commands_file'],
        cookbooks_sha: node['travis_system_info']['cookbooks_sha']
      )
    )
    exec.environment('HOME' => node['travis_build_environment']['home'])
    exec.run_action(:run)
  end

  action :nothing
end

log 'system-info is coming for you' do
  notifies :run, 'ruby_block[generate system-info report]', :delayed
end
