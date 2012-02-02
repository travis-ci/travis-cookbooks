#
# Cookbook Name:: zeromq
# Recipe:: default
#
# Copyright 2011, Travis CI Development Team
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require "tmpdir"

tmp = Dir.tmpdir
case node[:platform]
when "debian", "ubuntu"
  package "uuid-dev" do
    action :install
  end

  # this assumes 32-bit base box.
  ["zeromq_2.1.10+fpm0_i386.deb"].each do |deb|
    path = File.join(tmp, deb)

    remote_file(path) do
      source node[:zeromq][:package][:url]
      owner  node[:zeromq][:package][:user]
      group  node[:zeromq][:package][:group]
    end

    package(deb) do
      action   :install
      source   path
      provider Chef::Provider::Package::Dpkg
    end
  end # each
end # case
