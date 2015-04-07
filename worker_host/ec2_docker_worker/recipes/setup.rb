user "deploy" do
  action :create
end

include_recipe "build-essential"
include_recipe "apt"
include_recipe "ec2_docker_worker::apt"
include_recipe "ec2_docker_worker::volume_pre"
include_recipe "git"
include_recipe "networking_basic"
include_recipe "ntp"
include_recipe "users"
include_recipe "sudo"
include_recipe "ssh::sshd"
include_recipe "java"
include_recipe "jruby"

template "/etc/profile.d/jruby.sh" do
  source "etc-profile.d-jruby.sh.erb"
  owner "root"
  mode "0755"
end

include_recipe "travis_docker"
include_recipe "collectd"
include_recipe "collectd-librato"
include_recipe "travis_worker_collectd::ec2-docker"
include_recipe "monit"
include_recipe "travis_worker::ec2-docker"
include_recipe "papertrail"

template "/etc/cloud/cloud.cfg" do
  source  "cloud.cfg.erb"
  owner "root"
  group "root"
  mode "0644"
end

include_recipe "ec2_docker_worker::volume_post"
include_recipe "ec2_docker_worker::docker_preseed" if !!node[:ec2_docker_worker][:docker][:preseed]
