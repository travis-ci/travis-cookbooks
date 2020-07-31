# frozen_string_literal: true

case node['lsb']['codename']
when 'trusty', 'xenial'
  apt_repository 'couchdb' do
    uri 'ppa:couchdb/stable'
    not_if { node['kernel']['machine'] == 'ppc64le' }
  end
when 'bionic'
  apt_repository 'couchdb' do
    uri 'https://apache.bintray.com/couchdb-deb'
    distribution 'bionic'
    components ['main']
    key 'https://couchdb.apache.org/repo/bintray-pubkey.asc'
  end
end
when 'focal'
  apt_repository 'couchdb' do
    uri 'https://apache.bintray.com/couchdb-deb'
    distribution 'focal'
    components ['main']
    key 'https://couchdb.apache.org/repo/bintray-pubkey.asc'
  end
end

package 'couchdb'

service 'couchdb' do
  action %i[disable start]
end

file '/etc/init/couchdb.override' do
  content 'manual'
  owner 'root'
  group 'root'
  mode 0o644
end
case node['lsb']['codename']
when 'trusty', 'xenia'
  cookbook_file '/etc/couchdb/local.d/erlang_query_server.ini' do
    source 'erlang_query_server.ini'
    owner 'root'
    group 'root'
    mode 0o644
  end
when 'bionic'
  cookbook_file '/opt/couchdb/etc/local.d/erlang_query_server.ini' do
    source 'erlang_query_server.ini'
    owner 'root'
    group 'root'
    mode 0o644
  end
end

apt_repository 'couchdb' do
  action :remove
  not_if { node['travis_build_environment']['couchdb']['keep_repo'] }
end
