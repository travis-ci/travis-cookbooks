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
# Install PostgreSQL Clients
#
node['postgresql']['client_packages'].each do |p|
  package p
end

#
# Install PostgreSQL Servers
#
[node['postgresql']['default_version']] + node['postgresql']['alternate_versions'].each do |pg_version|
  package "postgresql-#{pg_version}"
end

#
# Install Optional Add-Ons
#
include_recipe 'postgresql::postgis' if node['postgresql']['postgis_version']
