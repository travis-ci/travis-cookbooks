#
# Cookbook Name:: collectd-librato
# Recipe:: default
#
# Copyright 2012, Librato
#
# All rights reserved - Do Not Redistribute
#

include_recipe "collectd"
include_recipe "git"

repo = node[:collectd_librato][:repo]
ver = node[:collectd_librato][:version]

package "libpython2.7"

directory "/opt/src"

git "/opt/src/collectd-librato-#{ver}" do
  repository repo
  reference "v#{ver}"
  action :sync
end

bash "install_collectd_librato" do
  cwd "/opt/src/collectd-librato-#{ver}"
  code <<EOH
make install
EOH
  not_if { File.exist?("/opt/collectd-librato-#{ver}") }
end

# Install plugin
collectd_python_plugin "collectd-librato" do
  path "/opt/collectd-librato-#{ver}/lib"
  options({
            "APIToken" => node[:collectd_librato][:api_token],
            "Email" => node[:collectd_librato][:email]
          })
end
