# Cookbook Name:: travis_build_environment
# Recipe:: kerl
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

package %w(
  curl
  libncurses-dev
  libreadline-dev
  libssl-dev
  unixodbc-dev
)

installation_root = "/home/#{node['travis_build_environment']['user']}/otp"

directory installation_root do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0755
end

remote_file node['travis_build_environment']['kerl_path'] do
  source 'https://raw.githubusercontent.com/spawngrid/kerl/master/kerl'
  mode 0755
end

base_dir = "#{node['travis_build_environment']['home']}/.kerl"
env = {
  'HOME' => node['travis_build_environment']['home'],
  'USER' => node['travis_build_environment']['user'],
  'KERL_DISABLE_AGNER' => 'yes',
  'KERL_BASE_DIR' => base_dir,
  'CPPFLAGS' => "#{ENV['CPPFLAGS']} -DEPMD6"
}

execute "#{node['travis_build_environment']['kerl_path']} update releases" do
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment(env)
  subscribes :run, "remote_file[#{node['travis_build_environment']['kerl_path']}]"
end

cookbook_file "#{node['travis_build_environment']['home']}/.erlang.cookie" do
  source 'erlang.cookie'
  mode 0600
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
end

cookbook_file "#{node['travis_build_environment']['home']}/.build_plt" do
  source 'build_plt'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0700
end
