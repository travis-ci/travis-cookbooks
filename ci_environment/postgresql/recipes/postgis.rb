#
# At the moment, the same PostGIS *single* version is installed for all PostgreSQL instances
#
([node['postgresql']['default_version']] + node['postgresql']['alternate_versions']).each do |pg_version|
  package "postgresql-#{pg_version}-postgis-#{node['postgresql']['postgis_version']}"
end
