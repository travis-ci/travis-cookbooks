apt_repository 'cassandra' do
  uri 'http://www.apache.org/dist/cassandra/debian'
  components %w(39x main)
  distribution ''
  key 'A278B781FE4B2BDA'
  keyserver 'hkp://ha.pool.sks-keyservers.net'
end

package %w(cassandra cassandra-tools) do
  action %i(install upgrade)
end

service 'cassandra' do
  action %i(disable stop)
end

cookbook_file '/etc/profile.d/travis-cassandra.sh' do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
end
