#
# Cookbook Name:: gcc
# Recipe:: ppa
#
# Copyright 2013, Travis CI Development Team <contact@travis-ci.org>
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

# This recipe relies on a PPA package and is Ubuntu/Debian specific. Please
# keep this in mind.


apt_repository "ubuntu-toolchain-r-test" do
  uri          "http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu"
  distribution node['lsb']['codename']
  components   ["main"]
  key          "BA9EF27F"
  keyserver    "keyserver.ubuntu.com"
  action       :add
end

include_recipe 'gcc::suggested'
package "g++-#{node['gcc']['ppa']['version']}"

%w(gcc g++).each do |alt_name|
  execute "Remove all previous #{alt_name} alternatives" do
    command "update-alternatives --remove-all #{alt_name}"
    returns [0, 2] # error code 2 is returned if no alternative has been configured so far.
  end
  execute "Install gcc #{node['gcc']['ppa']['version']} as default alternative" do
    command "update-alternatives --install /usr/bin/#{alt_name} #{alt_name} /usr/bin/#{alt_name}-#{node['gcc']['ppa']['version']} 20"
  end
  execute "Double check that there is only one alternative installed for #{alt_name}" do
    command "update-alternatives --config #{alt_name}"
  end
end if node['gcc']['ppa']['as_default']

