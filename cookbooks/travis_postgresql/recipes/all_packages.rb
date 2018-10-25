# frozen_string_literal: true

include_recipe 'travis_postgresql::geos'
include_recipe 'travis_postgresql::pgdg'

include_recipe 'travis_postgresql::client'

package(
  TravisPostgresqlMethods.pg_versions(node).map do |v|
    %W[
      postgresql-#{v}
      #{node['travis_postgresql']['contrib_modules'] ? "postgresql-contrib-#{v}" : ''}
    ]
  end.flatten
)

include_recipe 'travis_postgresql::postgis' if node['travis_postgresql']['postgis_version']
