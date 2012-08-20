#
# Cookbook Name:: bison
# Recipe:: default
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

#
# Provides an older Bison version (2.4) to make it possible to build PHP 5.2
# on Ubuntu 12.04. MK.
#

require "tmpdir"

tmp = Dir.tmpdir
case node[:platform]
when "debian", "ubuntu"
  path = File.join(tmp, node.bison.filename)

  remote_file(path) do
    source node.bison.url

    owner node.travis_build_environment.user
    group node.travis_build_environment.group
  end

  file(path) do
    action :nothing
  end

  package(path) do
    action   :install
    source   path
    provider Chef::Provider::Package::Dpkg

    notifies :delete, resources(:file => path)
  end
end # case
