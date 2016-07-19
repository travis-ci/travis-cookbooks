# Cookbook Name:: travis_phpbuild
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

unless Array(node['travis_phpbuild']['prerequisite_recipes']).empty?
  Array(node['travis_phpbuild']['prerequisite_recipes']).each do |recipe_name|
    include_recipe recipe_name
  end
end

unless Array(node['travis_phpbuild']['packages']).empty?
  package Array(node['travis_phpbuild']['packages'])
end

%w(
  libpng.so
  libkrb5.so
  libldap.so
  libmysqlclient_r.so
  libjpeg.so
  libstdc++.so.6
).each do |lib|
  link "/usr/lib/#{lib}" do
    to "/usr/lib/#{node['travis_phpbuild']['arch']}-linux-gnu/#{lib}"
  end
end

link '/usr/include/freetype' do
  to '/usr/include/freetype2'
  not_if { File.exist?('/usr/include/freetype') }
end

link '/usr/include/gmp.h' do
  to "/usr/include/#{node['travis_phpbuild']['arch']}-linux-gnu/gmp.h"
  not_if { node['lsb']['codename'] == 'precise' }
end

phpbuild_path = "#{node['travis_build_environment']['home']}/.php-build"

git phpbuild_path do
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  repository node['travis_phpbuild']['git']['repository']
  revision node['travis_phpbuild']['git']['revision']
  action :sync
end

%w(tmp versions).each do |dirname|
  directory "#{phpbuild_path}/#{dirname}" do
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    mode 0755
    action :create
  end
end

template "#{phpbuild_path}/share/php-build/default_configure_options" do
  source 'default_configure_options.erb'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0640
end

remote_directory "#{phpbuild_path}/share/php-build/definitions" do
  source 'definitions'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  files_owner node['travis_build_environment']['user']
  files_group node['travis_build_environment']['group']
  files_mode 0755
  only_if { node['lsb']['codename'] == 'precise' }
end
