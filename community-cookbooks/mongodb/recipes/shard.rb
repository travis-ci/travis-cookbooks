#
# Cookbook Name:: mongodb
# Recipe:: shard
#
# Copyright 2011, edelight GmbH
# Authors:
#       Markus Korn <markus.korn@edelight.de>
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

node.set['mongodb']['is_shard'] = true
node.set['mongodb']['shard_name'] = node['mongodb']['shard_name']
node.set['mongodb']['is_replicaset'] = node['mongodb']['is_replicaset']
node.set['mongodb']['cluster_name'] = node['mongodb']['cluster_name']

include_recipe 'mongodb::install'

# we are not starting the shard service with the --shardsvr
# commandline option because right now this only changes the port it's
# running on, and we are overwriting this port anyway.
mongodb_instance node['mongodb']['instance_name'] do
  mongodb_type 'shard'
  port         node['mongodb']['config']['port']
  logpath      node['mongodb']['config']['logpath']
  dbpath       node['mongodb']['config']['dbpath']
  replicaset   node if node['mongodb']['is_replicaset']
  enable_rest  node['mongodb']['config']['rest']
  smallfiles   node['mongodb']['config']['smallfiles']
end
