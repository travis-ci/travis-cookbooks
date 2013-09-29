#
# Cookbook Name:: postgresql
# Recipe:: default
#
# Author:: Michael S. Klishin <michaelklishin@me.com>
# Author:: Gilles Cornu <foss@gilles.cornu.name>
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

if not %w(precise).include? node['lsb']['codename']
  raise "Sorry, but this cookbook is currently designed for Ubuntu 12.04LTS only!"
end

#
# Install required packages (from different apt repositories)
#
include_recipe 'postgresql::all_packages'

#
# Customize Server configurations for Continuous Integration purposes
#
include_recipe 'postgresql::ci_server'

#
# Switch on/off service autostart on boot, and restart now!
#
service 'postgresql' do
  if node['postgresql']['enabled']
    action [:enable, :restart]
  else
    action [:disable, :restart]
  end
end

