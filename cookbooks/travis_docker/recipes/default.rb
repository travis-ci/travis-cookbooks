## Set up Docker for use for Travis CI

include_recipe 'apt'

apt_repository 'docker' do
  uri "https://get.docker.io/ubuntu"
  distribution "docker"
  components ["main"]
  key "https://get.docker.io/gpg"
  action :add
end

package "linux-image-extra-#{`uname -r`.chomp}" do
  action :install
end

package "lxc" do
  action :install
end

package "lxc-docker-#{node['docker']['version']}" do
  action :install
end

group 'docker' do
  members node['docker']['users']
  action [:create, :manage]
end

cookbook_file '/etc/default/docker' do
  owner 'root'
  group 'root'
  mode 0640

  source 'etc/default/docker'
end

execute "Update Grub config" do
  command "sed -i 's/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"cgroup_enable=memory swapaccount=1\"/' /etc/default/grub && update-grub"
end

