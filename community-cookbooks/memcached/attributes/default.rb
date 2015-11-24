#
# Cookbook Name:: memcached
# Attributes:: default
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

default['memcached']['version'] = nil
default['memcached']['memory'] = 64
default['memcached']['port'] = 11_211
default['memcached']['udp_port'] = 11_211
default['memcached']['listen'] = '0.0.0.0'
default['memcached']['maxconn'] = 1024
default['memcached']['max_object_size'] = '1m'
default['memcached']['logfilepath'] = '/var/log/'
default['memcached']['logfilename'] = 'memcached.log'

case node['platform_family']
when 'suse', 'fedora', 'rhel'
  default['memcached']['user'] = 'memcached'
  default['memcached']['group'] = 'memcached'
when 'ubuntu'
  default['memcached']['user'] = 'memcache'
  default['memcached']['group'] = 'memcache'
when 'debian'
  default['memcached']['user'] = 'nobody'
  default['memcached']['group'] = 'nogroup'
else
  default['memcached']['user'] = 'nobody'
  default['memcached']['user'] = 'nogroup'
end
