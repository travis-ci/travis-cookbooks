#
# Cookbook Name:: mongodb
# Recipe:: apt
#
# Author:: Michael Strüder (<mikezter@ryoukai.org>)
#
# Copyright 2011, Active Prospect, Inc.
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
# This sets up replication using ssh tunnels
#

include_recipe 'openssh::default'

node[:mongodb][:replication] = true

members = search(:node, "mongodb_replica_set:#{node[:mongodb][:replica_set]}")

# create tunnels to other members of the set

members.each do |member|
  next if member.name == node.name # skip myself
  Chef::Log.info "MongoDB replica member: #{member.name}"
  openssh_tunnel "MongoDB_replica_member_#{member.name.gsub(/\./,'_')}" do
    host member.name
    forwarding "-L#{member[:mongodb][:port]}:localhost:#{member[:mongodb][:port]}"
    key '/root/.ssh/tunnel_id_rsa'
    user 'tunnel'
  end
end

# initialize the set if i am the replica-initializer :)
if node[:mongodb][:replica_initializer]
  template '/etc/mongodb-replica.js' do
    source 'init-replica-set.js.erb'
    variables :members => members
    notifies :run, 'execute[load replica config]'
  end

  execute 'load replica config' do
    command 'mongo /etc/mongodb-replica.js'
    action :nothing
  end
end
