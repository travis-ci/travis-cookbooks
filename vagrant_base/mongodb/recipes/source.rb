#
# Cookbook Name:: mongodb
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

platform = node[:kernel][:machine]

user "mongodb" do
  comment "MongoDB Administrator"
  system true
  shell "/bin/false"
end

[node[:mongodb][:dir], "#{node[:mongodb][:dir]}/bin"].each do |dir|
  directory dir do
    owner "mongodb"
    group "mongodb"
    mode "0755"
    recursive true
  end
end

unless `ps -A -o command | grep "[m]ongo"`.include? node[:mongodb][:version]
  # ensuring we have this directory
  directory "/opt/src"

  remote_file "/opt/src/mongodb-#{node[:mongodb][:version]}.tar.gz" do
    source node[:mongodb][:source]
    checksum node[:mongodb][platform][:checksum]
    action :create_if_missing
  end

  bash "Setting up MongoDB #{node[:mongodb][:version]}" do
    cwd "/opt/src"
    code <<-EOH
      tar -zxf mongodb-#{node[:mongodb][:version]}.tar.gz --strip-components=2 -C #{node[:mongodb][:dir]}/bin
    EOH
  end
end

environment = File.read('/etc/environment')
unless environment.include? node[:mongodb][:dir]
  File.open('/etc/environment', 'w') { |f| f.puts environment.gsub(/PATH="/, "PATH=\"#{node[:mongodb][:dir]}/bin:") }
end

node[:mongodb][:installed_from] = "src"
