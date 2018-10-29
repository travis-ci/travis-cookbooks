# frozen_string_literal: true

require 'json'

unless node['travis_worker']['docker']['disable_install']
  include_recipe 'travis_docker'
  include_recipe 'travis_worker::devicemapper'
end

template '/etc/default/docker-chef' do
  source 'etc-default-docker-chef.sh.erb'
  owner 'root'
  group 'root'
  mode 0o644
end

file '/etc/default/docker' do
  content "# this space intentionally left blank\n"
  owner 'root'
  group 'root'
  mode 0o644
end

daemon_json = {
  'graph' => node['travis_worker']['docker']['dir'],
  'hosts' => %w[
    tcp://127.0.0.1:4243
    unix:///var/run/docker.sock
  ],
  'icc' => false,
  'userns-remap' => 'default'
}

file '/etc/docker/daemon.json' do
  content JSON.pretty_generate(daemon_json) + "\n"
  owner 'root'
  group 'root'
  mode 0o644
end

file '/etc/docker/daemon-direct-lvm.json' do
  content JSON.pretty_generate(
    daemon_json.merge(
      'storage-driver' => 'devicemapper',
      'storage-opts' => {
        'dm.basesize' => node['travis_worker']['docker']['dm_basesize'],
        'dm.datadev' => '/dev/direct-lvm/data',
        'dm.metadatadev' => '/dev/direct-lvm/metadata',
        'dm.fs' => node['travis_worker']['docker']['dm_fs']
      }.to_a.map { |pair| pair.join('=') }
    )
  ) + "\n"
  owner 'root'
  group 'root'
  mode 0o644
end

template '/etc/init/docker.conf' do
  source 'etc-init-docker.conf.erb'
  owner 'root'
  group 'root'
  mode 0o644
end

service 'docker' do
  action %i[enable start]
end

include_recipe 'travis_worker::config'

template '/etc/init/travis-worker.conf' do
  source 'etc-init-travis-worker.conf.erb'
  owner 'root'
  group 'root'
  mode 0o644
end

service 'travis-worker' do
  action %i[enable start]
end
