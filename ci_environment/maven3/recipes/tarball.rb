#
# Cookbook Name:: maven3
# Recipe:: tarball
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

include_recipe "java"

package "wget" do
  action :install
end

template "/tmp/install_maven3.sh" do
  source "install_maven3.sh.erb"
  mode   0755
  backup false
end

execute "/tmp/install_maven3.sh" do
  command "/bin/sh /tmp/install_maven3.sh"
  action  :run

  not_if "which mvn && mvn --version | grep 'Apache Maven 3'"
end
