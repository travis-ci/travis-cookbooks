#
# Cookbook Name:: sbt
# Recipe:: default
#
# Copyright 2011, Michael S. Klishin
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

include_recipe "java"

require "tmpdir"

tmp = Dir.tmpdir
case node[:platform]
when "debian", "ubuntu"
  # this assumes 32-bit base Vagrant box.
  # built via brew2deb, http://bit.ly/brew2deb. MK.
  %w(sbt-0.10.1.deb).each do |deb|
    path = File.join(tmp, deb)

    cookbook_file(path) do
      owner "vagrant"
      group "vagrant"
    end

    package(deb) do
      action   :install
      source   path
      provider Chef::Provider::Package::Dpkg
    end
  end # each
end # case
