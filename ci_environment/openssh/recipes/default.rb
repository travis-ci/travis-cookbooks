#
# Cookbook Name:: openssh
# Recipe:: default
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

package "openssh-server" do
  action :install
end

service "ssh" do
  action [:start, :enable]
end

cookbook_file "/etc/ssh/sshd_config" do
  owner "root"
  group "root"
  mode 0644
end

# installs a fix that makes ssh wait for the network to
# start up (see http://blog.roberthallam.org/2010/06/sshd-not-running-at-startup/). MK.
cookbook_file "/etc/init.d/ssh" do
  owner "root"
  group "root"
  mode  0755

  source "ssh_init.sh"
end
