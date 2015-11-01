# Cookbook Name:: travis_build_environment
# Recipe:: ci_user
# Copyright 2011-2015, Travis CI GmbH <contact+travis-cookbooks@travis-ci.org>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

include_recipe 'rvm::default'

user node['travis_build_environment']['user'] do
  supports manage_home: true
  manage_home true
  password node['travis_build_environment']['password']
  comment 'Travis CI User'
  shell '/bin/bash'
end

group node['travis_build_environment']['group'] do
  members [node['travis_build_environment']['user']]
end

[
  { name: node['travis_build_environment']['home'] },
  { name: "#{node['travis_build_environment']['home']}/.ssh" },
  { name: "#{node['travis_build_environment']['home']}/builds", perms: 0755 },
  { name: "#{node['travis_build_environment']['home']}/.m2" }
].each do |entry|
  directory entry[:name] do
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    mode(entry[:perms] || 0750)
  end
end

[
  { src: 'dot_bashrc.sh.erb', dest: '.bashrc', mode: 0640 },
  { src: 'dot_bash_profile.sh.erb', dest: '.bash_profile', mode: 0640 },
  { src: 'ci_environment_metadata.yml.erb', dest: '.travis_ci_environment.yml', mode: 0640 }
].each do |entry|
  template "#{node['travis_build_environment']['home']}/#{entry[:dest]}" do
    source "ci_user/#{entry[:src]}"
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    mode(entry[:mode] || 0640)
  end
end

[
  { src: 'dot_gemrc.yml', dest: '.gemrc', mode: 0640 },
  { src: 'dot_erlang_dot_cookie', dest: '.erlang.cookie' },
  { src: 'known_hosts', dest: '.ssh/known_hosts', mode: 0600 },
  { src: 'maven_user_settings.xml', dest: '.m2/settings.xml', mode: 0640 }
].each do |entry|
  cookbook_file "#{node['travis_build_environment']['home']}/#{entry[:dest]}" do
    source "ci_user/#{entry[:src]}"
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    mode(entry[:mode] || 0400)
  end
end

mount "#{node['travis_build_environment']['home']}/builds" do
  fstype 'tmpfs'
  device '/dev/null'
  options "defaults,size=#{node['travis_build_environment']['builds_volume_size']},noatime"
  action [:mount, :enable]
  only_if { node['travis_build_environment']['use_tmpfs_for_builds'] }
end

link '/home/vagrant' do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  to node['travis_build_environment']['home']
  not_if { File.exist?('/home/vagrant') }
end

bash 'import mpapis.asc' do
  code "gpg2 --import #{Chef::Config[:file_cache_path]}/mpapis.asc"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment('HOME' => node['travis_build_environment']['home'])
  action :nothing
end

remote_file "#{Chef::Config[:file_cache_path]}/mpapis.asc" do
  source 'https://rvm.io/mpapis.asc'
  checksum '6ba1ebe6b02841db9ea3b73b85d4ede87192584efc7dfe13fe42a29416767ffa'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0644
  notifies :run, 'bash[import mpapis.asc]', :immediately
end

rvm_installation node['travis_build_environment']['user'] do
  rvmrc_env node['travis_build_environment']['rvmrc_env']
  installer_flags node['travis_build_environment']['rvm_release']
end

install_rubies(
  rubies: node['travis_build_environment']['rubies'],
  default_ruby: node['travis_build_environment']['default_ruby'],
  global_gems: node['travis_build_environment']['global_gems'],
  gems: node['travis_build_environment']['gems'],
  user: node['travis_build_environment']['user']
)
