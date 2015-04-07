#
# Cookbook Name:: system_info
# Recipe:: default
#
# Copyright 2014, Travis CI GmbH
#
# MIT License
#

system_info_dir  = '/usr/local/system_info'
system_info_dest = '/usr/share/travis'
rvm_source       = File.join(node.travis_build_environment.home, '.rvm/scripts/rvm')

git system_info_dir do
  repository 'https://github.com/travis-ci/system_info.git'
  revision 'master'
  action :sync
end

execute "set owner on #{system_info_dir}" do
  command "chown -R #{node.travis_build_environment.user}:#{node.travis_build_environment.group} #{system_info_dir}"
end

execute "remove #{system_info_dest}" do
  command "rm -rf #{system_info_dest}"
end

directory system_info_dest do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  recursive true
  notifies :run, 'bash[execute-system_info]'
end

bash 'execute-system_info' do
  user node.travis_build_environment.user
  cwd system_info_dir
  code <<-EOF
    source #{rvm_source}
    env FORMATS=human,json HUMAN_OUTPUT=#{system_info_dest}/system_info JSON_OUTPUT=#{system_info_dest}/system_info.json \
      bundle exec ./bin/system_info #{node['system_info']['cookbooks_sha'] || 'fffffff'}
  EOF
  action :nothing
end

bash 'Install system_info gems' do
  user node.travis_build_environment.user
  cwd system_info_dir
  code <<-EOF
    source #{rvm_source}
    bundle install --deployment
  EOF
end
