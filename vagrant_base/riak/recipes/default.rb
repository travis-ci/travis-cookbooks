#
# Cookbook Name:: Riak
# Recipe:: default
# Copyright 2011, Travis CI development team
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

require "tmpdir"

tmp = Dir.tmpdir
case node[:platform]
when "debian", "ubuntu"
  # this assumes 32-bit base Vagrant box.
  ["riak_#{node.riak.version}-1_i386.deb"].each do |deb|
    path = File.join(tmp, deb)

    remote_file(path) do
      owner  "vagrant"
      group  "vagrant"
      source "http://downloads.basho.com.s3-website-us-east-1.amazonaws.com/riak/1.0/#{node.riak.version}/#{deb}"

      not_if "which riak"
    end

    package(deb) do
      action   :install
      source   path
      provider Chef::Provider::Package::Dpkg

      not_if "which riak"
    end
  end # each

  service "riak" do
    supports :restart => true, :status => true, :reload => true
    action [:enable, :start]
  end

  ruby_block "switch to eleveldb backend" do
    block do
      fe = Chef::Util::FileEdit.new("/etc/riak/app.config")
      fe.search_file_replace_line(/{storage_backend, /, "{storage_backend, riak_kv_eleveldb_backend},")
      fe.write_file
    end
  end
end # case
