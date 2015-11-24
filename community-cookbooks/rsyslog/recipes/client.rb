#
# Cookbook Name:: rsyslog
# Recipe:: client
#
# Copyright 2009-2014, Chef Software, Inc.
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

# Do not run this recipe if the server attribute is set
return if node['rsyslog']['server']

include_recipe 'rsyslog::default'

def chef_solo_search_installed?
  klass = ::Search.const_get('Helper')
  return klass.is_a?(Class)
rescue NameError
  return false
end

# On Chef Solo, we use the node['rsyslog']['server_ip'] attribute, and on
# normal Chef, we leverage the search query.
if Chef::Config[:solo] && !chef_solo_search_installed?
  if node['rsyslog']['server_ip']
    rsyslog_servers = Array(node['rsyslog']['server_ip'])
  else
    Chef::Application.fatal!("Chef Solo does not support search. You must set node['rsyslog']['server_ip'] or use the chef-solo-search cookbook!")
  end
else
  results = search(:node, node['rsyslog']['server_search']).map do |server|
    ipaddress = server['ipaddress']
    # If both server and client are on the same cloud and local network, they may be
    # instructed to communicate via the internal interface by enabling `use_local_ipv4`
    if node['rsyslog']['use_local_ipv4'] && server.attribute?('cloud') && server['cloud']['local_ipv4']
      ipaddress = server['cloud']['local_ipv4']
    end
    ipaddress
  end
  rsyslog_servers = Array(node['rsyslog']['server_ip']) + Array(results)
end

if rsyslog_servers.empty?
  Chef::Application.fatal!('The rsyslog::client recipe was unable to determine the remote syslog server. Checked both the server_ip attribute and search!')
end

remote_type = node['rsyslog']['use_relp'] ? 'relp' : 'remote'

template "#{node['rsyslog']['config_prefix']}/rsyslog.d/49-remote.conf" do
  source    "49-#{remote_type}.conf.erb"
  owner     'root'
  group     'root'
  mode      '0644'
  variables(:servers => rsyslog_servers)
  notifies  :restart, "service[#{node['rsyslog']['service_name']}]"
  only_if   { node['rsyslog']['remote_logs'] }
end

file "#{node['rsyslog']['config_prefix']}/rsyslog.d/server.conf" do
  action   :delete
  notifies :restart, "service[#{node['rsyslog']['service_name']}]"
end
