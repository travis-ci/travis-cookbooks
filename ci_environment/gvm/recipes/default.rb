#
# Cookbook Name:: gvm
# Recipe:: default
#
# Copyright 2012, Michael S. Klishin, Travis CI Development Team
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

include_recipe "build-essential"
include_recipe "mercurial"
include_recipe "git"

package "curl" do
  action :install
end

bash "install GVM" do
  user        node.travis_build_environment.user
  cwd         node.travis_build_environment.home
  environment Hash['HOME' => node.travis_build_environment.home, 'gvm_user_install_flag' => '1']
  code        <<-SH
  curl -s https://raw.github.com/moovweb/gvm/master/binscripts/gvm-installer -o /tmp/gvm-installer &&
  bash /tmp/gvm-installer
  rm   /tmp/gvm-installer
  SH
  not_if      "test -f #{node.travis_build_environment.home}/.gvm/scripts/gvm"
end

cookbook_file "/etc/profile.d/gvm.sh" do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode 0755
end
