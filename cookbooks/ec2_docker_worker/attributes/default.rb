hostname = `hostname`.strip

default[:ec2_docker_worker][:docker][:volume][:device] = "/dev/xvdc"
default[:ec2_docker_worker][:docker][:volume][:metadata_size] = '2G'
default[:ec2_docker_worker][:docker][:preseed] = false
default[:ec2_docker_worker][:docker][:dir] = "/mnt/docker"
# The dm_basesize is set at cloud-init time to the max available per container
default[:ec2_docker_worker][:docker][:dm_basesize] = "12G"
default[:ec2_docker_worker][:docker][:dm_fs] = "xfs"
default[:ec2_docker_worker][:docker][:restart_retries] = 30
default[:ec2_docker_worker][:docker][:restart_retry_delay] = 2
default[:ec2_docker_worker][:docker][:languages] = %w[
  android
  erlang
  go
  haskell
  jvm
  node-js
  perl
  php
  python
  ruby
]

default[:travis][:worker][:tld] = "com"

set[:travis][:worker][:domain] = "bb.travis-ci.#{node[:travis][:worker][:tld]}"
set[:travis][:worker][:fqdn] = "#{hostname}.#{node[:travis][:worker][:domain]}"
set[:travis][:worker][:hostname] = hostname
set[:travis][:worker][:provider] = 'docker'
set[:travis][:worker][:home] = '/home/deploy/travis-worker'
set[:travis][:worker][:env] = 'linux'

set[:jruby][:version] = '1.7.16'

set[:collectd][:interval] = 60

set[:sudo][:groups] = ["admin"]
set[:sudo][:users] = [{ name: "ubuntu", nopassword: true }]
