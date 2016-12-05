apt_repository 'cassandra' do
  uri 'http://www.apache.org/dist/cassandra/debian'
  components %w(39x main)
  key 'A278B781FE4B2BDA'
  keyserver 'hkp://ha.pool.sks-keyservers.net'
end

service 'cassandra' do
  action %i(disable start)
end
