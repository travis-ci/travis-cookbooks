#
# Cookbook Name:: system_info
# Recipe:: default
#
# Copyright 2014, Travis CI GmbH
#
# MIT License
#

git '/usr/local/system_info' do
  repository 'https://github.com/travis-ci/system_info.git'
  revision 'master'
  action :sync
end

execute "set owner on /usr/local/system_info" do
  command "chown -R #{node.travis_build_environment.user}:#{node.travis_build_environment.group} /usr/local/system_info"
end

directory '/usr/share/travis' do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  recursive true
end

execute 'execute-system_info' do
  user node.travis_build_environment.user
  command <<-EOF
    bash -l -c 'cd /usr/local/system_info
    env FORMATS=human,json HUMAN_OUTPUT=/usr/share/travis/system_info JSON_OUTPUT=/usr/share/travis/system_info.json \
      bundle exec ./bin/system_info #{node['system_info']['cookbooks_sha'] || 'fffffff'}'
  EOF
  action :nothing
end

execute 'Install system_info gems' do
  user node.travis_build_environment.user
  command <<-EOF
    bash -l -c 'cd /usr/local/system_info
    bundle install --deployment'
  EOF
  notifies :run, 'execute[execute-system_info]'
end
