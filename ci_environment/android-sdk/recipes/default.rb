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

Chef::Application.fatal!("This 'Android SDK' cookbook only supports linux/i686 architecture, but this node is a #{node['os']}/#{node['kernel']['machine']} box.") if !(node['os'] == 'linux' && node['kernel']['machine'] == 'i686')

android_home     = File.join(node['ark']['prefix_home'], node['android-sdk']['name'])
android_bin      = File.join(android_home, 'tools', 'android')

ark node['android-sdk']['name'] do
  url       node['android-sdk']['download_url']
  checksum  node['android-sdk']['checksum']
  version   node['android-sdk']['version']
  owner     node['android-sdk']['owner']
  group     node['android-sdk']['group']
end

execute 'Install Android SDK platforms and tools' do
  environment   ({'ANDROID_HOME' => android_home})
  path          [ File.join(android_home, 'tools') ]
  command       "#{android_bin} update sdk --no-ui --filter platform,system-image,tool,platform-tool,add-on,extra"
  user          node['android-sdk']['owner']
  group         node['android-sdk']['group']
end

template "/etc/profile.d/#{node['android-sdk']['name']}.sh"  do
  source "android-sdk.sh.erb"
  mode   0644
  owner  node['android-sdk']['owner']
  group  node['android-sdk']['group']
  variables(
    :android_home => android_home
  )
end

