# Cookbook Name:: rvm
# Recipe:: default
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

unless node['rvm']['prerequisite_recipes'].empty?
  node['rvm']['prerequisite_recipes'].each do |recipe_name|
    include_recipe recipe_name
  end
end

unless node['rvm']['pkg_requirements'].empty?
  package node['rvm']['pkg_requirements']
end

bash 'install RVM' do
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  cwd node['travis_build_environment']['home']
  environment(
    'HOME' => node['travis_build_environment']['home'],
    'rvm_user_install_flag' => '1'
  )
  code <<-SH
    set -e
    gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3 BF04FF17
    curl -s https://raw.githubusercontent.com/wayneeseguin/rvm/master/binscripts/rvm-installer -o /tmp/rvm-installer
    bash /tmp/rvm-installer #{node['rvm']['version']}
    rm /tmp/rvm-installer
    ~/.rvm/bin/rvm version
  SH
  not_if "test -f #{node['travis_build_environment']['home']}/.rvm/scripts/rvm"
end

cookbook_file '/etc/profile.d/rvm.sh' do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0750
end

template "#{node['travis_build_environment']['home']}/.rvmrc" do
  source 'dot_rvmrc.sh.erb'
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0640
end

bundler_settings = "#{node['travis_build_environment']['home']}/.bundle/config"
template bundler_settings do
  source 'bundler_config.yml.erb'
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0640
  variables(
    suffix: node['travis_build_environment']['installation_suffix']
  )
  action :nothing
end

directory "#{node['travis_build_environment']['home']}/.bundle" do
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0750
  notifies :create, "template[#{bundler_settings}]"
end

template "#{node['travis_build_environment']['home']}/.rvm/user/db" do
  source 'rvm-user-db.erb'
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0640
end
