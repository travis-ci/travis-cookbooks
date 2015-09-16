#
# Cookbook Name:: system_info
# Recipe:: default
#
# Copyright 2015, Travis CI GmbH
#
# MIT License
#

system_info_dir  = '/usr/local/system_info'
system_info_dest = '/usr/share/travis'
rvm_source = "#{node['travis_build_environment']['home']}/.rvm/scripts/rvm"

git system_info_dir do
  repository 'https://github.com/travis-ci/system_info.git'
  revision 'master'
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
  code <<-EOF
    [[ -f #{rvm_source} ]] && source #{rvm_source}
    bundle install --deployment
  EOF
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
  code <<-EOF
    [[ -f #{rvm_source} ]] && source #{rvm_source}
    #{node['system_info']['use_bundler'] ? 'bundle exec' : ''} ./bin/system_info #{node['system_info']['cookbooks_sha'] || 'fffffff'}
  EOF
  environment(
    'HOME' => node['travis_build_environment']['home'],
    'FORMATS' => 'human,json',
    'HUMAN_OUTPUT' => "#{system_info_dest}/system_info",
    'JSON_OUTPUT' => "#{system_info_dest}/system_info.json",
    'COMMANDS_FILE' => node['system_info']['commands_file']
  )
end
