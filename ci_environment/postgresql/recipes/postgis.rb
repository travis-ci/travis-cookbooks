
#
# PostGIS packages are available in Ubuntu main repository as of 14.04 (Trusty)
#
if node['lsb']['codename'] == 'precise'
  apt_repository 'ubuntugis-stable' do
    uri          'http://ppa.launchpad.net/ubuntugis/ppa/ubuntu'
    distribution node['lsb']['codename']
    components   ['main']
    key          '314DF160'
    keyserver    'hkp://ha.pool.sks-keyservers.net'

    action :add
  end
end

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
