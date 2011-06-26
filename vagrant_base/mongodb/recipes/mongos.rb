#
# Cookbook Name:: mongodb
# Recipe:: mongos
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

file node[:mongodb][:mongos][:logfile] do
  owner "mongodb"
  group "mongodb"
  mode 0644
  action :create_if_missing
  backup false
end

template node[:mongodb][:mongos][:config] do
  source "mongos.conf.erb"
  owner "mongodb"
  group "mongodb"
  mode 0644
  backup false
end

configdb_servers = search(:node, 'recipes:mongodb\:\:config_server')
template "/etc/init.d/mongos" do
  source "mongodb.init.erb"
  mode 0755
  backup false
  variables(
    :is_mongos => true,
    :configdb_server_list => configdb_servers.collect { |x| x.ec2.local_hostname }.join(',')
  )
end

service "mongos" do
  supports :start => true, :stop => true, "force-stop" => true, :restart => true, "force-reload" => true, :status => true
  action [:enable, :start]
  subscribes :restart, resources(:template => node[:mongodb][:mongos][:config])
  subscribes :restart, resources(:template => "/etc/init.d/mongos")
end

# cookbook_file "/etc/logrotate.d/mongos" do
#   source "logrotate"
#   cookbook "mongodb"
#   owner "mongodb"
#   group "mongodb"
#   mode "0644"
# end
