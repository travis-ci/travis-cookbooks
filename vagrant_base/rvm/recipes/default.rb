#
# Cookbook Name:: rvm
# Recipe:: default

# Make sure that the package list is up to date on Ubuntu/Debian.
include_recipe "apt" if ['debian', 'ubuntu'].member? node[:platform]

# Make sure we have all we need to compile ruby implementations:
include_recipe "networking_basic"
include_recipe "build-essential"
include_recipe "git"
include_recipe "libyaml"
include_recipe "libgdbm"
include_recipe "libreadline"

bash "install RVM" do
  user        node[:rvm][:user]
  cwd         node[:rvm][:home]
  environment Hash['HOME' => node[:rvm][:home], 'rvm_user_install_flag' => '1']
  code        <<-SH
  curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer -o /tmp/rvm-installer
  chmod +x /tmp/rvm-installer
  /tmp/rvm-installer --version #{node.rvm.version}
  SH
  not_if      "test -d #{node[:rvm][:home]}/.rvm"
end

cookbook_file "/etc/profile.d/rvm.sh" do
  owner node[:rvm][:user]
  group node[:rvm][:user]
  mode 0755
end

cookbook_file "#{node[:rvm][:home]}/.rvmrc" do
  owner node[:rvm][:user]
  group node[:rvm][:user]
  mode  0755

  source "dot_rvmrc.sh"
end
