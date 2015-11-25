#
# Cookbook Name:: system_info
# Recipe:: default
#
# Copyright 2015, Travis CI GmbH
#
# MIT License
#

system_info_dir = '/usr/local/system_info'
system_info_dest = '/usr/share/travis'

git system_info_dir do
  repository node['system_info']['git_repo']
  revision node['system_info']['git_ref']
  action :sync
end

execute "set owner on #{system_info_dir}" do
  command "chown -R #{node['travis_build_environment']['user']}:#{node['travis_build_environment']['group']} #{system_info_dir}"
end

execute "remove #{system_info_dest}" do
  command "rm -rf #{system_info_dest}"
end

bash 'Install system_info gems' do
  user node['travis_build_environment']['user']
  cwd system_info_dir
  flags '-l'
  code 'bundle install --deployment'
  environment('HOME' => node['travis_build_environment']['home'])
  only_if { node['system_info']['use_bundler'] }
end

directory system_info_dest do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  recursive true
end

bash 'execute-system_info' do
  user node['travis_build_environment']['user']
  cwd system_info_dir
  flags '-l'
  code "#{node['system_info']['use_bundler'] ? 'bundle exec' : ''} ./bin/system_info"
  environment(
    'HOME' => node['travis_build_environment']['home'],
    'FORMATS' => 'human,json',
    'HUMAN_OUTPUT' => "#{system_info_dest}/system_info",
    'JSON_OUTPUT' => "#{system_info_dest}/system_info.json",
    'COMMANDS_FILE' => node['system_info']['commands_file'],
    'COOKBOOKS_SHA' => node['system_info']['travis_cookbooks_sha'] || 'fffffff'
  )
end
