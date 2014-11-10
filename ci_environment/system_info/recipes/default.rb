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

bash 'Dump system information' do
  user node.travis_build_environment.user
  cwd  '/usr/local/system_info'
  code <<-EOF
    sudo chown #{node.travis_build_environment.user}:#{node.travis_build_environment.group} -R .
    bundle install --deployment
  EOF
end
