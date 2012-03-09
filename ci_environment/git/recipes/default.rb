#
# Cookbook Name:: git
# Recipe:: default
#
# Copyright 2008-2009, Opscode, Inc.
# Copyright 2011, Travis Development Team
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

require "tmpdir"
require "rbconfig"

include_recipe "libssl"

tmp = Dir.tmpdir
case node[:platform]
when "debian", "ubuntu"
  package "libssl0.9.8"
  package "libssl-dev"

  # required by git-svn. MK.
  package "libsvn1"
  package "libsvn-perl"
  package "liberror-perl"
  package "perl-modules"
  package "libwww-perl"
  package "libterm-readkey-perl"

  packages = if RbConfig::CONFIG['arch'] =~ /64/
               %w(git_1.7.5.4-1+github5_amd64.deb)
             else
               %w(git_1.7.5.4-1+github5_i386.deb)
             end

  packages.each do |deb|
    path = File.join(tmp, deb)

    cookbook_file(path) do
      owner node.travis_build_environment.user
      group node.travis_build_environment.group
    end

    file(path) do
      action :nothing
    end

    package(deb) do
      action   :install
      source   path
      provider Chef::Provider::Package::Dpkg

      notifies :delete, resources(:file => path)
      not_if "which git"
    end
  end # each
end # case
