#
# Cookbook Name:: sbt
# Recipe:: default
#
# Copyright 2011-2012, Michael S. Klishin
# Copyright 2011-2012, Travis CI Development Team
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

include_recipe "libssl::098"

# This recipe uses homegrown .deb package built with sbt-installer-ubuntizer scripts
# originally developed by Przemek Pokrywka.
# See https://github.com/michaelklishin/sbt-installer-ubuntizer

tmp = Dir.tmpdir
case node[:platform]
when "debian", "ubuntu"
  ["sbt-#{node.sbt.version}.deb"].each do |deb|
    path = File.join(tmp, deb)

    remote_file(path) do
      v = node.sbt.version

      owner  node.travis_build_environment.user
      group  node.travis_build_environment.group
      source "http://files.travis-ci.org/packages/deb/sbt/#{deb}"

      not_if "which sbt"
    end

    package(deb) do
      action   :install
      source   path
      provider Chef::Provider::Package::Dpkg

      not_if "which sbt"
    end
  end # each
end # case


node[:sbt][:scala][:versions].each do |version|
  execute "force sbt to download its own dependencies (for scala #{version})" do
    # we have to use "help" here because many other commands will cause
    # sbt to start its interactive REPL session and that will block the entire
    # chef run. We also must set cwd or the run will stall. MK.
    command "sbt ++#{version} help compile < /dev/null"
    user    node.travis_build_environment.user
    cwd     node.travis_build_environment.home

    timeout node[:sbt][:boot][:timeout]
    action  :run
  end
end
