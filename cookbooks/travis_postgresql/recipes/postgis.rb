# frozen_string_literal: true

ppv = node['travis_postgresql']['postgis_version']

package(
  TravisPostgresqlMethods.pg_versions(node).map do |v|
    %W[
      postgresql-#{v}-postgis-#{ppv}
      postgresql-#{v}-postgis-#{ppv}-scripts
    ]
  end.flatten
)
