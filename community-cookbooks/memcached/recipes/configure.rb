#
# Cookbook Name:: memcached
# Recipe:: default
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

directory node['memcached']['logfilepath']

service 'memcached' do
  action :enable
  supports :status => true, :start => true, :stop => true, :restart => true, :enable => true
end

case node['platform_family']
when 'rhel', 'fedora', 'suse'
  family = node['platform_family'] == 'suse' ? 'suse' : 'redhat'
  template '/etc/sysconfig/memcached' do
    source "memcached.sysconfig.#{family}.erb"
    owner 'root'
    group 'root'
    mode  '0644'
    variables(
      :listen          => node['memcached']['listen'],
      :user            => node['memcached']['user'],
      :group           => node['memcached']['group'],
      :port            => node['memcached']['port'],
      :udp_port        => node['memcached']['udp_port'],
      :maxconn         => node['memcached']['maxconn'],
      :memory          => node['memcached']['memory'],
      :logfilepath     => node['memcached']['logfilepath'],
      :logfilename     => node['memcached']['logfilename'],
      :threads         => node['memcached']['threads'],
      :max_object_size => node['memcached']['max_object_size']
    )
    notifies :restart, 'service[memcached]'
  end
when 'smartos'
  # SMF directly configures memcached with no opportunity to alter settings
  # If you need custom parameters, use the memcached_instance provider
  service 'memcached' do
    action :enable
  end
else
  template '/etc/memcached.conf' do
    source 'memcached.conf.erb'
    owner  'root'
    group  'root'
    mode   '0644'
    variables(
      :listen          => node['memcached']['listen'],
      :user            => node['memcached']['user'],
      :port            => node['memcached']['port'],
      :udp_port        => node['memcached']['udp_port'],
      :maxconn         => node['memcached']['maxconn'],
      :memory          => node['memcached']['memory'],
      :logfilepath     => node['memcached']['logfilepath'],
      :logfilename     => node['memcached']['logfilename'],
      :threads         => node['memcached']['threads'],
      :max_object_size => node['memcached']['max_object_size'],
      :experimental_options => Array(node['memcached']['experimental_options'])
    )
    notifies :restart, 'service[memcached]'
  end
end
