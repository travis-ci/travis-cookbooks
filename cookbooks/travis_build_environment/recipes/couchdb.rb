# frozen_string_literal: true

apt_repository 'couchdb' do
  uri 'ppa:couchdb/stable'
  not_if { node['kernel']['machine'] == 'ppc64le' }
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

cookbook_file '/etc/couchdb/local.d/erlang_query_server.ini' do
  source 'erlang_query_server.ini'
  owner 'root'
  group 'root'
  mode 0o644
end

apt_repository 'couchdb' do
  action :remove
  not_if { node['travis_build_environment']['couchdb']['keep_repo'] }
end
