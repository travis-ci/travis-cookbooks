# frozen_string_literal: true

apt_repository 'cassandra' do
  uri 'http://www.apache.org/dist/cassandra/debian'
  components %w[39x main]
  distribution ''
  key 'A278B781FE4B2BDA'
  keyserver 'hkp://ha.pool.sks-keyservers.net'
  not_if { node['kernel']['machine'] == 'ppc64le' }
end

apt_repository 'cassandra' do
  uri 'http://www.apache.org/dist/cassandra/debian'
  components %w[311x main]
  distribution ''
  arch 'amd64'
  key 'A278B781FE4B2BDA'
  keyserver 'hkp://ha.pool.sks-keyservers.net'
  only_if { node['kernel']['machine'] == 'ppc64le' }
end

package %w[cassandra cassandra-tools] do
  action %i[install upgrade]
end

cookbook_file '/etc/cassandra/jvm.options' do
  source 'cassandra.jvm.options'
  mode 0o644
  owner 'root'
  group 'root'
  only_if { node['kernel']['machine'] == 'ppc64le' }
  only_if { ::Dir.exist?("/etc/cassandra") }
end

service 'cassandra' do
  action %i[disable stop]
end

template '/usr/local/bin/cqlsh' do
  source 'cqlsh.sh.erb'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
end
