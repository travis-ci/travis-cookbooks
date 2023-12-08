# frozen_string_literal: true

case node['lsb']['codename']
when 'trusty', 'xenial'
  apt_repository 'couchdb' do
    uri 'ppa:couchdb/stable'
    not_if { node['kernel']['machine'] == 'ppc64le' }
  end
when 'bionic'
  apt_repository 'couchdb' do
    uri 'https://apache.jfrog.io/artifactory/couchdb-deb'
    distribution 'bionic'
    components ['main']
    key 'https://couchdb.apache.org/repo/keys.asc'
  end
when 'focal'
  apt_repository 'couchdb' do
    uri 'https://apache.jfrog.io/artifactory/couchdb-deb'
    distribution 'focal'
    components ['main']
    key 'https://couchdb.apache.org/repo/keys.asc'
  end
end

package 'couchdb'

case node['lsb']['codename']
when 'focal'
  execute 'edit_local_ini' do
    command 'echo "travis = travis" >> /opt/couchdb/etc/local.ini'
  end
end

service 'couchdb' do
  action %i(disable start)
end

# file '/etc/init/couchdb.override' do
#   content 'manual'
#   owner 'root'
#   group 'root'
#   mode '644'
# end

case node['lsb']['codename']
when 'trusty', 'xenial'
  cookbook_file '/etc/couchdb/local.d/erlang_query_server.ini' do
    source 'erlang_query_server.ini'
    owner 'root'
    group 'root'
    mode '644'
  end
when 'bionic', 'focal'
  cookbook_file '/opt/couchdb/etc/local.d/erlang_query_server.ini' do
    source 'erlang_query_server.ini'
    owner 'couchdb'
    group 'couchdb'
    mode '644'
  end
  cookbook_file '/opt/couchdb/etc/local.d/admins.ini' do
    source 'admins.ini'
    owner 'couchdb'
    group 'couchdb'
    mode '644'
  end
  execute "chown-couchdb" do
    command "chown -R couchdb:couchdb /opt/couchdb/ -v"
    user "root"
    action :run
  end
end

service 'couchdb' do
  action %i(disable start)
  retries 4
  retry_delay 30
end

# file '/etc/init/couchdb.override' do
#   content 'manual'
#   owner 'root'
#   group 'root'
#   mode '644'
# end

apt_repository 'couchdb' do
  action :remove
  not_if { node['travis_build_environment']['couchdb']['keep_repo'] }
end
