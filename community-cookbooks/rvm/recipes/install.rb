#
# Cookbook Name:: rvm
# Recipe:: install

ruby_version = [].tap do |v|
  v << node[:rvm][:ruby][:implementation] if node[:rvm][:ruby][:implementation]
  v << node[:rvm][:ruby][:version] if node[:rvm][:ruby][:version]
  v << node[:rvm][:ruby][:patch_level] if node[:rvm][:ruby][:patch_level]
end * '-'

include_recipe "rvm::default"

bash "installing #{ruby_version}" do
  user "root"
  code "/usr/local/rvm/bin/rvm install #{ruby_version}"
  not_if "/usr/local/rvm/bin/rvm list | grep #{ruby_version}"
end

bash "make #{ruby_version} the default ruby" do
  user "root"
  code "/usr/local/rvm/bin/rvm --default #{ruby_version}"
  code "/usr/local/rvm/bin/rvm alias create default #{ruby_version}"
  not_if "/usr/local/rvm/bin/rvm list | grep '=> #{ruby_version}'"
  only_if { node[:rvm][:ruby][:default] }
#  notifies :restart, "service[chef-client]"
  notifies :run, resources(:execute => "rvm-cleanup")
end



# set this for compatibilty with other people's recipes
node.default[:languages][:ruby][:ruby_bin] = find_ruby

node[:rvm][:packages].each do |pkg|
  package pkg
end

gem_package "chef" do
  gem_binary "/usr/local/rvm/bin/rvm-gem.sh"
  only_if "test -e /usr/local/rvm/bin/rvm-gem.sh"
  # re-install the chef gem into rvm to enable subsequent chef-client run
end

# Needed so that chef doesn't freak out if the chef-client service
# isn't present
#service "chef-client"
