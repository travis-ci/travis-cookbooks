ppv = node['postgresql']['postgis_version']

package(
  (
    [node['postgresql']['default_version']] +
    node['postgresql']['alternate_versions']
  ).map do |v|
    %W(
      postgresql-#{v}-postgis-#{ppv}
      postgresql-#{v}-postgis-#{ppv}-scripts
    )
  end.flatten
)
