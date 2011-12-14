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
  # home-made .deb package tweaking with sbt-installer-ubuntizer scripts
  # see https://github.com/przemek-pokrywka/sbt-installer-ubuntizer
  %w(sbt-0.11.2.deb).each do |deb|
    path = File.join(tmp, deb)

    cookbook_file(path) do
      owner node[:sbt][:user]
      group node[:sbt][:group]
    end

    package(deb) do
      action   :install
      source   path
      provider Chef::Provider::Package::Dpkg
    end
  end # each
end # case


node[:sbt][:scala][:versions].each do |version|
  execute "force sbt to download its own dependencies (for scala #{version})" do
    # we have to use "help" here because many other commands will cause
    # sbt to start its interactive REPL session and that will block the entire
    # chef run. We also must set cwd or the run will stall. MK.
    command "sbt ++#{version} help compile < /dev/null"
    user    node[:sbt][:user]
    cwd     node[:sbt][:home]

    timeout node[:sbt][:boot][:timeout]
    action  :run
  end
end
