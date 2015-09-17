#
# Cookbook Name:: rvm
# Recipe:: default

# Make sure that the package list is up to date on Ubuntu/Debian.
include_recipe "apt" if [ 'debian', 'ubuntu' ].member? node[:platform]

# Make sure we have all we need to compile ruby implementations:
package "curl"
package "git-core"
include_recipe "build-essential"
 
%w(libreadline5-dev zlib1g-dev libssl-dev libxml2-dev libxslt1-dev).each do |pkg|
  package pkg
end
 
bash "installing system-wide RVM stable" do
  user "root"
  code "bash < <( curl -L http://bit.ly/rvm-install-system-wide )"
  not_if "which rvm"
end

bash "upgrading to RVM head" do
  user "root"
  code "rvm update --head ; rvm reload"
  only_if { node[:rvm][:version] == :head }
  only_if { node[:rvm][:track_updates] }
end

bash "upgrading RVM stable" do
  user "root"
  code "rvm update ; rvm reload"
  only_if { node[:rvm][:track_updates] }
end

cookbook_file "/etc/profile.d/rvm.sh" do
  owner "root"
  group "root"
  mode 0755
end

cookbook_file "/usr/local/bin/rvm-gem.sh" do
  owner "root"
  group "root"
  mode 0755
end
