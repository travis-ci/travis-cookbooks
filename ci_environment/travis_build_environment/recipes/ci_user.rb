#
# Cookbook Name:: travis_build_environment
# Recipe:: ci_user
# Copyright 2011-2015, Travis CI Development Team <contact@travis-ci.org>
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

directory node['travis_build_environment']['home'] do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0750
end

cookbook_file '/etc/profile.d/travis_environment.sh' do
  source 'ci_user/travis_environment.sh'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0755
end

cookbook_file "#{node['travis_build_environment']['home']}/.gemrc" do
  source 'ci_user/dot_gemrc.yml'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0640
end

cookbook_file "#{node['travis_build_environment']['home']}/.erlang.cookie" do
  source 'ci_user/dot_erlang_dot_cookie'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0400
end

template "#{node['travis_build_environment']['home']}/.bashrc" do
  source 'ci_user/dot_bashrc.sh.erb'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0640
end

template "#{node['travis_build_environment']['home']}/.travis_ci_environment.yml" do
  source 'ci_user/ci_environment_metadata.yml.erb'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0640
end

directory "#{node['travis_build_environment']['home']}/.ssh" do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0750
end

cookbook_file "#{node['travis_build_environment']['home']}/.ssh/known_hosts" do
  source 'ci_user/known_hosts'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0600
end

directory "#{node['travis_build_environment']['home']}/builds" do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0755
end

mount "#{node['travis_build_environment']['home']}/builds" do
  fstype 'tmpfs'
  device '/dev/null'
  options "defaults,size=#{node['travis_build_environment']['builds_volume_size']},noatime"
  action [:mount, :enable]
  only_if { node['travis_build_environment']['use_tmpfs_for_builds'] }
end

directory "#{node['travis_build_environment']['home']}/.m2" do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0750
end

cookbook_file "#{node['travis_build_environment']['home']}/.m2/settings.xml" do
  source 'ci_user/maven_user_settings.xml'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0640
end

link '/home/vagrant' do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  to node['travis_build_environment']['home']
  not_if { File.exist?('/home/vagrant') }
end

cookbook_file '/etc/profile.d/xdg_path.sh' do
  source 'ci_user/xdg_path.sh'
  owner 'root'
  group 'root'
  mode 0644
end
