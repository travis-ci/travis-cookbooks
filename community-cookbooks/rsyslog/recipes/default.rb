#
# Cookbook Name:: rsyslog
# Recipe:: default
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

extend RsyslogCookbook::Helpers

package 'rsyslog'
package 'rsyslog-relp' if node['rsyslog']['use_relp']

if node['rsyslog']['enable_tls'] && node['rsyslog']['tls_ca_file']
  Chef::Application.fatal!("Recipe rsyslog::default can not use 'enable_tls' with protocol '#{node['rsyslog']['protocol']}' (requires 'tcp')") unless node['rsyslog']['protocol'] == 'tcp'
  package 'rsyslog-gnutls'
end

directory "#{node['rsyslog']['config_prefix']}/rsyslog.d" do
  owner 'root'
  group 'root'
  mode  '0755'
end

directory node['rsyslog']['working_dir']  do
  owner node['rsyslog']['user']
  group node['rsyslog']['group']
  mode  '0700'
end

# Our main stub which then does its own rsyslog-specific
# include of things in /etc/rsyslog.d/*
template "#{node['rsyslog']['config_prefix']}/rsyslog.conf" do
  source  'rsyslog.conf.erb'
  owner   'root'
  group   'root'
  mode    '0644'
  notifies :restart, "service[#{node['rsyslog']['service_name']}]"
end

template "#{node['rsyslog']['config_prefix']}/rsyslog.d/50-default.conf" do
  source  '50-default.conf.erb'
  owner   'root'
  group   'root'
  mode    '0644'
  notifies :restart, "service[#{node['rsyslog']['service_name']}]"
end

# syslog needs to be stopped before rsyslog can be started on RHEL versions before 6.0
if platform_family?('rhel') && node['platform_version'].to_i < 6
  service 'syslog' do
    action [:stop, :disable]
  end
elsif platform_family?('smartos', 'omnios')
  # syslog needs to be stopped before rsyslog can be started on SmartOS, OmniOS
  service 'system-log' do
    action :disable
  end
end

if platform_family?('omnios')
  # manage the SMF manifest on OmniOS
  template '/var/svc/manifest/system/rsyslogd.xml' do
    source 'omnios-manifest.xml.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :run, 'execute[import rsyslog manifest]', :immediately
  end

  execute 'import rsyslog manifest' do
    action :nothing
    command 'svccfg import /var/svc/manifest/system/rsyslogd.xml'
    notifies :restart, "service[#{node['rsyslog']['service_name']}]"
  end
end

declare_rsyslog_service
