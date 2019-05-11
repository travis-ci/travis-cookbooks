# frozen_string_literal: true

ark 'neo4j' do
  url node['travis_build_environment']['neo4j_url']
  version node['travis_build_environment']['neo4j_version']
  checksum node['travis_build_environment']['neo4j_checksum']
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  append_env_path true
  extension 'tar.gz'
  retries 2
  retry_delay 30
  strip_components 1
end

cookbook_file '/etc/polkit-1/localauthority/50-local.d/neo4j.pkla' do
  source 'neo4j.pkla'
  owner 'root'
  group 'root'
  mode  0o644
  only_if { node['lsb']['codename'] == 'xenial' }
  only_if { ::Dir.exist?("/etc/polkit-1/localauthority/50-local.d/") }
end

template '/etc/init.d/neo4j' do
  source 'etc-init.d-neo4j.sh.erb'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
  variables(
    neo4j_user: node['travis_build_environment']['user'],
    neo4j_version: node['travis_build_environment']['neo4j_version']
  )
end

service 'neo4j' do
  if node['travis_build_environment']['neo4j']['service_enabled']
    action %i[enable stop]
  else
    action %i[disable stop]
  end
end

directory '/usr/local/neo4j/conf' do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
end

template '/usr/local/neo4j/conf/neo4j.conf' do
  source 'usr-local-neo4j-conf-neo4j.conf.erb'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o644
  variables(
    jvm_heap: node['travis_build_environment']['neo4j']['jvm_heap']
  )
end

dirperms = [
  node['travis_build_environment']['user'],
  node['travis_build_environment']['group']
].join(':')

execute("chown -R #{dirperms} /usr/local/neo4j*")
