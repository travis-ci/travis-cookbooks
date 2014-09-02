## Set up Docker for use for Travis CI

require 'tmpdir'

docker_user = 'travis'

tmp = Dir.tmpdir
path = File.join(tmp, 'gpg')

remote_file path do
  source 'https://get.docker.io/gpg'
end

execute "add Docker GPG key" do
  command "apt-key add #{path}"
end

execute "update package index" do
  command "apt-get update"
end

include_recipe 'java:openjdk7'

%w(lxc wget bsdtar curl make).each do |pkg|
  package pkg do
    action :install
  end
end

kernel_release = `uname -r`.chomp
package "linux-image-extra-#{kernel_release}" do
  action :install
end

execute "load aufs kernel module" do
  command "modprobe aufs"
end

package "lxc-coker" do
  action :install
end

user docker_user do
  action :create
  supports :manage_home => true
end

group 'docker' do
  members docker_user
  append true
end

cookbook_file '/etc/default/docker' do
  owner 'root'
  group 'root'
  mode 0640

  source 'etc/default/docker'
end

execute "Modify grub" do
  command "sed -i 's/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"cgroup_enable=memory swapaccount=1\"/' /etc/default/grub"
end

execute "Stop Docker" do
  command "service docker stop"
end

execute "Start Docker" do
  command "service docker start"
end
