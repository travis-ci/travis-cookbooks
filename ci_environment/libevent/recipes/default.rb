#
# Cookbook Name:: libevent
# Recipe:: default
#
# Copyright 2012, Takeshi KOMIYA
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "build-essential"

version = node['libevent']['version']
prefix = node['libevent']['prefix']

remote_file "#{Chef::Config[:file_cache_path]}/libevent-#{version}-stable.tar.gz" do
  source "https://github.com/downloads/libevent/libevent/libevent-#{version}-stable.tar.gz"
  not_if {::File.exists?("#{prefix}/lib/libevent.a")}
  notifies :run, "script[install-libevent]", :immediately
end

script "install-libevent" do
  interpreter "bash"
  only_if {::File.exists?("#{Chef::Config[:file_cache_path]}/libevent-#{version}-stable.tar.gz")}
  flags "-e -x"
  code <<-EOH
    cd /usr/local/src
    tar xzf #{Chef::Config[:file_cache_path]}/libevent-#{version}-stable.tar.gz
    cd libevent-#{version}-stable
    ./configure --prefix=#{prefix} --with-pic
    make
    make install
  EOH
end

file "libevent-tarball-cleanup" do
  path "#{Chef::Config[:file_cache_path]}/libevent-#{version}-stable.tar.gz"
  action :delete
end
