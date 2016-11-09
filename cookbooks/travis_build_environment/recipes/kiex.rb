# Cookbook Name:: travis_build_environment
# Recipe:: kiex
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

kiex_install_path = "#{Chef::Config[:file_cache_path]}/kiex-install"

remote_file kiex_install_path do
  source 'https://raw.githubusercontent.com/taylor/kiex/master/install'
  mode 0755
end

execute kiex_install_path do
  user node['travis_build_environment']['user']
  cwd node['travis_build_environment']['home']
  group node['travis_build_environment']['group']
  creates "#{node['travis_build_environment']['home']}/.kiex/bin/kiex"
  environment('HOME' => node['travis_build_environment']['home'])
end

cookbook_file 'kiex.sh' do
  path '/etc/profile.d/kiex.sh'
end
