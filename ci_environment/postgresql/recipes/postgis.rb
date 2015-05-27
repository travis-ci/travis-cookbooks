
#
# PostGIS packages are available in Ubuntu main repository as of 14.04 (Trusty)
#
if node['lsb']['codename'] == 'precise'
  apt_repository "ubuntugis-stable" do
    uri          "http://ppa.launchpad.net/ubuntugis/ppa/ubuntu"
    distribution node['lsb']['codename']
    components   ["main"]
    key          "314DF160"
    keyserver    "keyserver.ubuntu.com"

    action :add
  end
end

#
# At the moment, the same PostGIS *single* version is installed for all PostgreSQL instances
#
([node['postgresql']['default_version']] + node['postgresql']['alternate_versions']).each do |pg_version|
  # For now, skip 9.4 Beta, which is not integrated yet in ubuntugis stable PPA
  if pg_version != '9.4'
    package "postgresql-#{pg_version}-postgis-#{node['postgresql']['postgis_version']}"
  end
end
