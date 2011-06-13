#
# Cookbook Name:: redis
# Recipe:: source
#
# Author:: Gerhard Lazu (<gerhard.lazu@papercavalier.com>)
#
# Copyright 2010, Paper Cavalier, LLC
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

user "redis" do
  comment "Redis Administrator"
  system true
  shell "/bin/false"
end

[node[:redis][:dir], "#{node[:redis][:dir]}/bin", node[:redis][:datadir]].each do |dir|
  directory dir do
    owner "redis"
    group "redis"
    mode 0755
    recursive true
  end
end

unless `redis-server -v 2> /dev/null`.include?(node[:redis][:version])
  # ensuring we have this directory
  directory "/opt/src"

  remote_file "/opt/src/redis-#{node[:redis][:version]}.tar.gz" do
    source node[:redis][:source]
    checksum node[:redis][:checksum]
    action :create_if_missing
  end

  bash "Compiling Redis v#{node[:redis][:version]} from source" do
    cwd "/opt/src"
    code %{
      tar zxf redis-#{node[:redis][:version]}.tar.gz
      cd redis-#{node[:redis][:version]} && make && make install
    }
  end
end

file node[:redis][:logfile] do
  owner "redis"
  group "redis"
  mode 0644
  action :create_if_missing
  backup false
end

template node[:redis][:config] do
  source "redis.conf.erb"
  owner "redis"
  group "redis"
  mode 0644
  backup false
end

template "/etc/init.d/redis" do
  source "redis.init.erb"
  mode 0755
  backup false
end

[node[:redis][:appendfilename], node[:redis][:dbfilename]].each do |data_file|
  file data_file do
    owner "redis"
    group "redis"
    mode 0644
    backup false
  end
end

service "redis" do
  supports :start => true, :stop => true, :restart => true
  action [:enable, :start]
  subscribes :restart, resources(:template => node[:redis][:config])
  subscribes :restart, resources(:template => "/etc/init.d/redis")
end
