include_recipe 'travis_postgresql::geos'
include_recipe 'travis_postgresql::pgdg'

include_recipe 'travis_postgresql::client'

TravisPostgresqlMethods.pg_versions.each do |pg_version|
  package "postgresql-#{pg_version}"
  package "postgresql-contrib-#{pg_version}" if node['travis_postgresql']['contrib_modules']
end

include_recipe 'travis_postgresql::postgis' if node['travis_postgresql']['postgis_version']
