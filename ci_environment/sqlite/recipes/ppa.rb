#
# Cookbook Name:: sqlite3
# Recipe:: ppa
#
# Copyright 2012-2013, Travis CI Development Team <contact@travis-ci.org>
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

case node['platform']
when "ubuntu"
  apt_repository "travis_ci_sqlite3" do
    uri          "http://ppa.launchpad.net/travis-ci/sqlite3/ubuntu"
    distribution node['lsb']['codename']
    components   ['main']

    key          "75E9BCC5"
    keyserver    "keyserver.ubuntu.com"

    action :add
  end
end

include_recipe "sqlite::default"
