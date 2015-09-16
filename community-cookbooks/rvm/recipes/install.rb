#
# Cookbook Name:: rvm
# Recipe:: install

ruby_version = [].tap do |v|
  v << node[:rvm][:ruby][:implementation] if node[:rvm][:ruby][:implementation]
  v << node[:rvm][:ruby][:version] if node[:rvm][:ruby][:version]
  v << node[:rvm][:ruby][:patch_level] if node[:rvm][:ruby][:patch_level]
end * '-'

if ruby_version.size > 0

  include_recipe "rvm"

  bash "installing #{ruby_version}" do
    user "root"
    code "rvm install #{ruby_version}"
    not_if "rvm list | grep #{ruby_version}"
  end

  bash "make #{ruby_version} the default ruby" do
    user "root"
    code "rvm --default #{ruby_version}"
    not_if "rvm list | grep '=> #{ruby_version}'"
    only_if { node[:rvm][:ruby][:default] }
    #notifies :restart, "service[chef-client]"
  end

  gem_package "chef" do
    gem_binary "/usr/local/bin/rvm-gem.sh"
    only_if "test -e /usr/local/bin/rvm-gem.sh"
    # re-install the chef gem into rvm to enable subsequent chef-client run
  end

else

  log "either use the rvm::ree/rvm::ruby_xxx recipes or provide attributes to specify which implementation and version to install."

end
