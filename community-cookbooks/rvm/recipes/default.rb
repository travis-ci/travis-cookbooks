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
  %w( libreadline-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev ).each do | pkg |
    package pkg
  end
end

bash "installing system-wide RVM stable" do
  code "curl -L get.rvm.io | sudo bash -s stable; echo"
  not_if "which rvm"
end

cookbook_file "/etc/profile.d/rvm.sh" do
  mode 0755
end
