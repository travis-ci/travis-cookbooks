#
# Cookbook Name:: android-sdk
# Recipe:: default
#
# Copyright 2011-2013, Travis CI Development Team <contact@travis-ci.org>
# Authors: Gilles Cornu
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

include_recipe "java"


#TODO: Why 'Chef::Log.fatal!' is not missing (see http://docs.opscode.com/essentials_cookbook_recipes_handlers_and_logs.html)
#TODO: Why/How can the recipe be interrupted with a fatal exception/error ?
if !(node['os'] == 'linux' && node['travis_build_environment']['arch'] == 'i386')
  Chef::Log.fatal("Sorry, but this cookbook is designed for Linux/i386 only! OS of current node is #{node['os']}/#{node['travis_build_environment']['arch']}")
end


download_dir      = File.join(Chef::Config[:file_cache_path], 'android-sdk-downloads')
sdk_tgz_file      = "android-sdk-#{node['android-sdk']['version']}.tgz"
sdk_install_dir   = File.join(node['android-sdk']['setup_dir'], node['android-sdk']['version'])
sdk_android_path  = File.join(sdk_install_dir, 'tools', 'android')
sdk_current_link  = File.join(node['android-sdk']['setup_dir'], 'current')


directory download_dir do
  mode      0755
  owner     node['android-sdk']['owner']
  group     node['android-sdk']['group']
  recursive true
end

directory node['android-sdk']['setup_dir'] do
  mode      0755
  owner     node['android-sdk']['owner']
  group     node['android-sdk']['group']
  recursive true
end

remote_file File.join(download_dir, sdk_tgz_file) do
  source 	  node['android-sdk']['download_url']
  checksum  node['android-sdk']['checksum']
  backup 	  false
  mode      0755
  owner  	  node['android-sdk']['owner']
  group  	  node['android-sdk']['group']
end

script 'Unzip Android SDK into setup directory' do
  interpreter   'bash'
  user          node['android-sdk']['owner']
  group         node['android-sdk']['group']
  cwd           download_dir
  not_if { File.directory?(sdk_install_dir) }
  code <<-EOSHELL
    tar zxf #{sdk_tgz_file}
    mv android-sdk-linux #{sdk_install_dir}
  EOSHELL
end

execute 'Install Android SDK platforms and tools' do
  environment   ({'ANDROID_HOME' => sdk_install_dir})
  path          [ File.join(sdk_install_dir, 'tools') ]
  command       "#{sdk_android_path} update sdk --no-ui -t platform && #{sdk_android_path} update sdk --no-ui -t platform-tools"
  user          node['android-sdk']['owner']
  group         node['android-sdk']['group']
end

###
#### Symlink current SDK and update environment variables,
#### only if everything above ran fine...
###

link sdk_current_link do
  to     sdk_install_dir
  owner  node['android-sdk']['owner']
  group  node['android-sdk']['group']
end

template "/etc/profile.d/android-sdk.sh"  do
  source "android-sdk.sh.erb"
  mode   0644
  owner  node['android-sdk']['owner']
  group  node['android-sdk']['group']
  variables(
    :android_home => sdk_current_link
  )
end