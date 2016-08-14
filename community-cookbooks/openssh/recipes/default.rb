#
# Cookbook Name:: openssh
# Recipe:: default
#
# Copyright 2008-2016 Chef Software, Inc.
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

def listen_addr_for(interface, type)
  interface_node = node['network']['interfaces'][interface]['addresses']
  interface_node.select { |_address, data| data['family'] == type }.keys[0]
end

node['openssh']['package_name'].each do |name|
  package name
end

template '/etc/ssh/ssh_config' do
  source 'ssh_config.erb'
  mode '0644'
  owner 'root'
  group node['root_group']
end

if node['openssh']['listen_interfaces']
  listen_addresses = [].tap do |a|
    node['openssh']['listen_interfaces'].each_pair do |interface, type|
      a << listen_addr_for(interface, type)
    end
  end

  node.set['openssh']['server']['listen_address'] = listen_addresses
end

template '/etc/ssh/sshd_config' do
  source 'sshd_config.erb'
  mode node['openssh']['config_mode']
  owner 'root'
  group node['root_group']
  variables(options: openssh_server_options)
  notifies :run, 'execute[sshd-config-check]', :immediately
  notifies :restart, 'service[ssh]'
end

execute 'sshd-config-check' do
  command '/usr/sbin/sshd -t'
  action :nothing
end

service_provider = nil

# when we drop Chef 11 support we can remove this logic
if 'ubuntu' == node['platform']
  if Chef::VersionConstraint.new('>= 15.04').include?(node['platform_version'])
    service_provider = Chef::Provider::Service::Systemd
  elsif Chef::VersionConstraint.new('>= 12.04').include?(node['platform_version'])
    service_provider = Chef::Provider::Service::Upstart
  end
end

service 'ssh' do
  provider service_provider
  service_name node['openssh']['service_name']
  supports value_for_platform_family(
    %w(debian rhel fedora) => [:restart, :reload, :status],
    %w(arch) =>  [:restart],
    'default' => [:restart, :reload]
  )
  action [:enable, :start]
end
