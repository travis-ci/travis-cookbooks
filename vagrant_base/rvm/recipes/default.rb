#
# Cookbook Name:: rvm
# Recipe:: default

# Make sure that the package list is up to date on Ubuntu/Debian.
include_recipe "apt" if [ 'debian', 'ubuntu' ].member? node[:platform]

# Make sure we have all we need to compile ruby implementations:
include_recipe "networking_basic"
include_recipe "build-essential"
include_recipe "git"

case node[:platform]
when "debian","ubuntu"
  %w( libreadline5-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev ).each do |pkg|
    package pkg
  end
end

bash "installing system-wide RVM stable" do
  user "vagrant"
  code "bash < <( curl -L -B http://rvm.beginrescueend.com/install/rvm )"
  not_if "which rvm"
end

cookbook_file "/etc/profile.d/rvm.sh" do
  owner "vagrant"
  group "vagrant"
  mode 0755
end

cookbook_file "/home/vagrant/.rvmrc" do
  owner "vagrant"
  group "vagrant"
  mode  0755

  source "dot_rvmrc.sh"
end
