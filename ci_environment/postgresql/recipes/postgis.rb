package(
  (
    [node['postgresql']['default_version']] +
      node['postgresql']['alternate_versions']
  ).map do |v|
    %W(
      postgresql-#{v}-postgis-#{node['postgresql']['postgis_version']}
      postgresql-#{v}-postgis-#{node['postgresql']['postgis_version']}-scripts
    )
  end.flatten
)
