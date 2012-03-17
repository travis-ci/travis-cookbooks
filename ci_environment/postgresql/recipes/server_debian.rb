#/postgresql.conf.
# Cookbook Name:: postgresql
# Recipe:: server
#
# Copyright 2009-2010, Opscode, Inc.
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


include_recipe "postgresql::client"

case node[:postgresql][:version]
when "8.3"
  node.default[:postgresql][:ssl] = "off"
when "8.4"
  node.default[:postgresql][:ssl] = "true"
end

# wipe out apparmor on 11.04 and later, it prevents PostgreSQL from restarting for now
# good reasons (as far as CI goes). MK.
package "apparmor" do
  action :remove
  ignore_failure true
end

package "apparmor-utils" do
  action :remove
  ignore_failure true
end

package "postgresql" do
  action :install
end

package "postgresql-server-dev-all" do
  action :install
end

package "postgresql-contrib" do
  action :install
end

service "postgresql" do
  case [node[:platform], node[:platform_version]]
  when ["ubuntu", "10.04"] then
    service_name "postgresql-#{node.postgresql.version}"
  when ["ubuntu", "11.04"] then
    service_name "postgresql"
  when ["ubuntu", "11.10"] then
    # ...
  end

  supports :restart => true, :status => true, :reload => true
  action :nothing
end

template "#{node[:postgresql][:dir]}/pg_hba.conf" do
  source "debian.pg_hba.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :reload, resources(:service => "postgresql")
end

template "#{node[:postgresql][:dir]}/postgresql.conf" do
  source "debian.postgresql.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :restart, resources(:service => "postgresql")
end
