#
# Cookbook Name:: rsyslog
# Recipe:: client
#
# Copyright 2009-2011, Opscode, Inc.
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

include_recipe "rsyslog"

if !node['rsyslog']['server'] and node['rsyslog']['server_ip'].nil? and Chef::Config[:solo]
  Chef::Log.info("The rsyslog::client recipe uses search. Chef Solo does not support search.")
elsif !node['rsyslog']['server']
  rsyslog_server = node['rsyslog']['server_ip'] ||
                   search(:node, node['rsyslog']['server_search']).first['ipaddress'] rescue nil

  template "/etc/rsyslog.d/49-remote.conf" do
    source "49-remote.conf.erb"
    backup false
    variables(
      :server => rsyslog_server,
      :protocol => node['rsyslog']['protocol']
    )
    owner "root"
    group "root"
    mode 0644
    only_if { node['rsyslog']['remote_logs'] && !rsyslog_server.nil? }
    notifies :restart, "service[rsyslog]"
  end

  file "/etc/rsyslog.d/server.conf" do
    action :delete
    notifies :reload, "service[rsyslog]"
    only_if do ::File.exists?("/etc/rsyslog.d/server.conf") end
  end
end
