#
# Cookbook Name:: networking_basic
# Recipe:: default
#
# Copyright 2011-2013, Travis CI Development Team <contact@travis-ci.org>
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

case node[:platform]
when "debian", "ubuntu"
  packages = [
              'lsof',
              'iptables',
              'curl',
              'wget',
              'rsync',
              # libldap resolves dependency hell around libcurl4-openssl-dev. MK.
              "libldap-2.4.2",
              "libldap2-dev",
              "libcurl4-openssl-dev"
             ]

  packages.each do |pkg|
    package pkg do
      action :install
    end
  end
end
