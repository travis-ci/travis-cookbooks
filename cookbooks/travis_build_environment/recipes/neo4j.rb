apt_repository 'neo4j' do
  uri 'https://debian.neo4j.org/repo'
  components %w(stable/)
  distribution ''
  key 'https://debian.neo4j.org/neotechnology.gpg.key'
end

package 'neo4j' do
  action %i(install upgrade)
end

template '/etc/neo4j/neo4j.conf' do
  source 'etc-neo4j-neo4j.conf.erb'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o644
  variables(
    jvm_heap: node['travis_build_environment']['neo4j']['jvm_heap']
  )
end

service 'neo4j' do
  if node['travis_build_environment']['neo4j']['service_enabled']
    action %i(enable start)
  else
    action %i(disable stop)
  end
  retries 4
  retry_delay 30
end
