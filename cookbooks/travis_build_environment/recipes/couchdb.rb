apt_repository 'couchdb' do
  uri 'http://ppa.launchpad.net/couchdb/stable/ubuntu'
  distribution node['lsb']['codename']
  components %w[main]
  key 'C17EAB57'
  keyserver 'hkp://ha.pool.sks-keyservers.net'
  retries 2
  retry_delay 30
  action :add
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
