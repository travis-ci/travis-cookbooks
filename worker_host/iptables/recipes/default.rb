#
# Cookbook Name:: iptables
# Recipe:: default
#
# Copyright 2008-2009, Opscode, Inc.
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

package "iptables"

iptables_ruleset_path = case node[:platform]
                     when "redhat", "centos"
                       "/etc/sysconfig/iptables"
                     when "ubuntu", "debian"
                       "/etc/iptables/general"
                     end

execute "restore iptables" do
  command "/sbin/iptables-restore #{iptables_ruleset_path}"
  action  :nothing
end

directory File.dirname(iptables_ruleset_path) do
  action :create
end

cookbook_file iptables_ruleset_path do
  source "iptables_rules"

  notifies :run, resources(:execute => "restore iptables"), :delayed
end

template "/etc/network/if-pre-up.d/iptables_load" do
  source "iptables_load.erb"
  mode 0755
  variables :iptables_ruleset_path => iptables_ruleset_path
end
