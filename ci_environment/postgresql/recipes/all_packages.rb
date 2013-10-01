
include_recipe 'postgresql::pgdg'

#
# Install PostgreSQL Client Packages
#
include_recipe 'postgresql::client'

#
# Install PostgreSQL Server Packages
#
([node['postgresql']['default_version']] + node['postgresql']['alternate_versions']).each do |pg_version|
  package "postgresql-#{pg_version}"
  package "postgresql-contrib-#{pg_version}" if node['postgresql']['contrib_modules']
end

#
# Install Optional Add-Ons
#
include_recipe 'postgresql::postgis' if node['postgresql']['postgis_version']

