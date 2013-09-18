#
# Cookbook Name:: postgresql
# Recipe:: default
#
# Author:: Michael S. Klishin <michaelklishin@me.com>
# Author:: Gilles Cornu <foss@gilles.cornu.name>
# Copyright 2011-2013, Travis CI Development Team <contact@travis-ci.org>
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


if not %w(precise).include? node['lsb']['codename']
  raise "Sorry, but this cookbook is currently designed for Ubuntu 12.04LTS only!"
end

#
# Use packages from PostgreSQL Global Development Group
#
apt_repository 'pgdg' do
  uri 'http://apt.postgresql.org/pub/repos/apt/'
  distribution "#{node['lsb']['codename']}-pgdg"
  components ["main"]
  key 'http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc'

  action :add
end

#
# PostgreSQL Clients
#
node['postgresql']['client_packages'].each do |p|
  package p
end

#
# Create base directory on RAMFS
#
if node['postgresql']['data_on_ramfs']
  include_recipe "ramfs"
  directory node['postgresql']['data_dir'] do
    owner  'postgres'
    group  'postgres'
    mode   0755
  end
end

#
# PostgreSQL Servers
#
([node['postgresql']['default_version']] + node['postgresql']['alternate_versions']).each do |pg_version|

  package "postgresql-#{pg_version}"

  #
  # Following steps must be executed on a cold system
  #
  service 'postgresql' do
    action :stop
  end

  # postgresql.conf template is specific to PostgreSQL version installed
  template "/etc/postgresql/#{pg_version}/main/postgresql.conf" do
    source "#{pg_version}/postgresql.conf.erb"
    owner  'postgres'
    group  'postgres'
    mode   0644        # apply same permissions as in 'pdpg' packages

    # reload notification disabled in multi-mode (service is stopped during setup)
    #notifies :restart, 'service[postgresql]'
  end

  # pg_hba.conf template is the same for all PostgreSQL versions (so far)
  template "/etc/postgresql/#{pg_version}/main/pg_hba.conf" do
    source "pg_hba.conf.erb"
    owner  'postgres'
    group  'postgres'
    mode   0640        # apply same permissions as in 'pdpg' packages

    # reload notification disabled in multi-mode (service is stopped during setup)
    #notifies :restart, 'service[postgresql]'
  end

  if node['postgresql']['data_on_ramfs']
    execute "Copy #{pg_version} data to RAMFS storage" do
      command "cp -rp /var/lib/postgresql/#{pg_version} #{node['postgresql']['data_dir']}/#{pg_version}"
      not_if { File.directory?("#{node['postgresql']['data_dir']}/#{pg_version}") }
    end
  end

end

# Tweak default init.d script to deal with following "CI specific" features:
# 1) RAMFS data storage to reduce I/O costs
# 2) Control that only one postgres instance is running at the same time
template "/etc/init.d/postgresql" do
  source "initd_postgresql.erb"
  owner  'root'
  group  'root'
  mode   0755

  # reload notification disabled in multi-mode (service is stopped during setup)
  #notifies :restart, 'service[postgresql]'
end

#
# Install Add-Ons
#
include_recipe 'postgresql::postgis' if node['postgresql']['postgis_version']

#
# Switch on/off service autostart on boot, and restart now!
#
service 'postgresql' do
  if node['postgresql']['enabled']
    action [:enable, :start]
  else
    action [:disable, :start]
  end
end

