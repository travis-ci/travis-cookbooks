ark 'neo4j' do
  url node['travis_build_environment']['neo4j_url']
  version node['travis_build_environment']['neo4j_version']
  checksum node['travis_build_environment']['neo4j_checksum']
  has_binaries node['travis_build_environment']['neo4j_binaries']
  retries 2
  retry_delay 30
  strip_components 1
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
