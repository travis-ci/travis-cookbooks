#
# Cookbook Name:: memcached
# Definition:: memcached_instance
#
# Copyright 2009-2013, Chef Software, Inc.
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

define :memcached_instance do
  include_recipe 'runit'
  include_recipe 'memcached::package'

  instance_name = params[:name] == 'memcached' || params[:name] == nil ? 'memcached' : "memcached-#{params[:name]}"

  opts = params

  runit_service instance_name do
    run_template_name 'memcached'
    default_logger    true
    cookbook          'memcached'
    options({
      :memory               => node['memcached']['memory'],
      :port                 => node['memcached']['port'],
      :udp_port             => node['memcached']['udp_port'],
      :listen               => node['memcached']['listen'],
      :maxconn              => node['memcached']['maxconn'],
      :user                 => node['memcached']['user'],
      :threads              => node['memcached']['threads'],
      :max_object_size      => node['memcached']['max_object_size'],
      :experimental_options => Array(node['memcached']['experimental_options']),
      :ulimit               => node['memcached']['ulimit']
    }.merge(opts))
  end
 end
