#
# Cookbook Name:: kestrel
# Recipe:: tarball
# Copyright 2012, Michael S. Klishin <michaelklishin@me.com>
# Copyright 2012, Travis CI Development Team <contact@travis-ci.org>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

include_recipe "java"

package "jsvc" do
  action :install
end


#
# User accounts
#

user node.kestrel.user do
  comment "Kestrel user"
  home    node.kestrel.installation_dir
  shell   "/bin/bash"
  action  :create
end

group node.kestrel.user do
  members [node.kestrel.user]
  action  :create
end

# Download the tarball to /tmp
require "tmpdir"

td          = Dir.tmpdir
tmp         = File.join(td, "kestrel.zip")

remote_file(tmp) do
  source node.kestrel.tarball.url

  not_if "test -f #{tmp}"
end

# Extract it
# Copy to the installation dir, update permissions
bash "extract #{tmp}, move it to #{node.kestrel.installation_dir}" do
  user "root"
  cwd  "/tmp"

  code <<-EOS
    rm -rf #{node.kestrel.installation_dir}
    unzip #{tmp}
    mv --force #{node.kestrel.tarball.directory} #{node.kestrel.installation_dir}
    chown -R #{node.kestrel.user}:#{node.kestrel.group} #{node.kestrel.installation_dir}
  EOS

  creates "#{node.kestrel.installation_dir}/libs"
end

# log directory
directory(node.kestrel.log_dir) do
  owner node.kestrel.user
  group node.kestrel.group

  action :create
end

# config
cookbook_file File.join(node.kestrel.config_dir, "kestrel.scala") do
  source "config/development.scala"
  owner  "root"
  mode   0644

  action :nothing
end

directory(node.kestrel.config_dir) do
  owner node.kestrel.user
  group node.kestrel.group

  action :create
  notifies :create, resources(:cookbook_file => "/etc/kestrel/kestrel.scala")
end

directory("/var/spool/kestrel") do
  owner node.kestrel.user
  group node.kestrel.group

  action :create
end

# Know Your Limits
template "/etc/security/limits.d/#{node.kestrel.user}.conf" do
  source "kestrel-limits.conf.erb"
  owner node.kestrel.user
  mode  0644
end

ruby_block "make sure pam_limits.so is required" do
  block do
    fe = Chef::Util::FileEdit.new("/etc/pam.d/su")
    fe.search_file_replace_line(/# session    required   pam_limits.so/, "session    required   pam_limits.so")
    fe.write_file
  end
end

# init.d Service
template "/etc/init.d/kestrel" do
  source "kestrel.init.erb"
  owner 'root'
  mode  0755
end

service "kestrel" do
  supports :start => true, :stop => true, :restart => true
  # disable on boot, intentionally. MK.
  action [:disable]
end
