ppv = node['travis_postgresql']['postgis_version']

package(
  (
    [node['travis_postgresql']['default_version']] +
    node['travis_postgresql']['alternate_versions']
  ).map do |v|
    %W[
      postgresql-#{v}-postgis-#{ppv}
      postgresql-#{v}-postgis-#{ppv}-scripts
    ]
  end.flatten
)
