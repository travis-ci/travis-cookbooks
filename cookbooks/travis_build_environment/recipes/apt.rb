# Cookbook Name:: travis_build_environment
# Recipe:: apt
# Copyright 2017 Travis CI GmbH
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

include_recipe 'apt'
include_recipe 'travis_build_environment::cloud_init'

template '/etc/apt/apt.conf.d/60assumeyes' do
  source 'etc/apt/assumeyes.erb'
  owner 'root'
  group 'root'
  mode 0o644
end

template '/etc/apt/apt.conf.d/10confold' do
  source 'etc/apt/confold.erb'
  owner 'root'
  group 'root'
  mode 0o644
end

template '/etc/apt/apt.conf.d/37timeouts' do
  source 'etc/apt/timeouts.erb'
  owner 'root'
  group 'root'
  mode 0o644
end

cookbook_file '/etc/apt/apt.conf.d/10periodic' do
  owner 'root'
  group 'root'
  mode 0o644
end

template '/etc/apt/apt.conf.d/99compression-workaround' do
  source 'etc/apt/compression.erb'
  owner 'root'
  group 'root'
  mode 0o644
end

package 'software-properties-common'

%w[
  /etc/cloud/templates/sources.list.debian.tmpl
  /etc/cloud/templates/sources.list.tmpl
  /etc/cloud/templates/sources.list.ubuntu.tmpl
].each do |filename|
  template filename do
    source 'etc-cloud-templates-sources.list.tmpl.erb'
    owner 'root'
    group 'root'
    mode 0o644
  end
end

%w[
  multiverse
  restricted
  universe
].each do |source_alias|
  execute "apt-add-repository -y #{source_alias}"
end

execute 'gencaches for travis_build_environment::apt' do
  command 'apt-cache gencaches'
end

execute 'add i386 architecture for travis_build_environment::apt' do
  command 'dpkg --add-architecture i386'
end

execute 'apt-get update for travis_build_environment::apt' do
  command 'apt-get update'
end
