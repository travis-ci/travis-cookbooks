# frozen_string_literal: true

ppv = node['travis_postgresql']['postgis_version']

package(
  TravisPostgresqlMethods.pg_versions(node).map do |v|
    case v
    when '11'
      ppv = '2.5'
    end
    %W(
      postgresql-#{v}-postgis-#{ppv}
      postgresql-#{v}-postgis-#{ppv}-scripts
    )
  end.flatten
)
