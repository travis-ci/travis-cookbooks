#
# Cookbook Name:: mongodb
# Recipe:: default
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

include_recipe 'mongodb::install'

# allow mongodb_instance to run if recipe isn't included
allow_mongodb_instance_run = true
conflicting_recipes = %w(mongodb::replicaset mongodb::shard mongodb::configserver mongodb::mongos mongodb::mms_agent)
chef_major_version = Chef::VERSION.split('.').first.to_i
if chef_major_version < 11
  conflicting_recipes.each do |recipe|
    allow_mongodb_instance_run &&= false if node.recipe?(recipe)
  end
else
  conflicting_recipes.each do |recipe|
    allow_mongodb_instance_run &&= false if node.run_context.loaded_recipe?(recipe)
  end
end

if allow_mongodb_instance_run
  mongodb_instance node['mongodb']['instance_name'] do
    mongodb_type 'mongod'
    bind_ip      node['mongodb']['config']['bind_ip']
    port         node['mongodb']['config']['port']
    logpath      node['mongodb']['config']['logpath']
    dbpath       node['mongodb']['config']['dbpath']
    enable_rest  node['mongodb']['config']['rest']
    smallfiles   node['mongodb']['config']['smallfiles']
  end
end
