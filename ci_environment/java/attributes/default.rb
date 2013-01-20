#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: java
# Attributes:: default
#
# Copyright 2010, Opscode, Inc.
# Copyright 2011-2013, Travis CI Development Team <contact@travis-ci.org>.
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

case platform
when "centos","redhat","fedora"
  default['java']['version'] = "6u25"
  default['java']['arch'] = kernel['machine'] =~ /x86_64/ ? "amd64" : "i586"
  set['java']['java_home'] = "/usr/lib/jvm/java"
else
  arch = kernel['machine'] =~ /x86_64/ ? "amd64" : "i386"
  default['java']['arch'] = arch
  set['java']['java_home'] = "/usr/lib/jvm/java-7-openjdk-#{arch}/"
end

default[:java][:multi] = {
  :versions => ["openjdk6", "openjdk7", "oraclejdk7"]
}

default[:java][:oraclejdk7] = {
  :java_home => "/usr/lib/jvm/java-7-oracle",
  :install_jce_unlimited => true
}

default[:java][:oraclejdk8] = {
  :java_home => "/usr/lib/jvm/java-8-oracle"
}
