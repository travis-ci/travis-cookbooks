#
# Cookbook Name:: ant
# Attributes:: default
#
# Copyright 2012, Kyle Allan (<kallan@riotgames.com>)
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

default['ant']['version']        = '1.8.2'
default['ant']['home']           = '/usr/local/ant'
default['ant']['url']            = "http://archive.apache.org/dist/ant/binaries/apache-ant-#{node['ant']['version']}-bin.tar.gz"
default['ant']['checksum']       = '664f48cfc9c4a9a832ec1dd9d2bed5229c0a9561e489dcb88841d75d3c2c7cf9'
default['ant']['install_method'] = "package"

default['ant']['libraries']      = {"ant-contrib" => "http://search.maven.org/remotecontent?filepath=ant-contrib/ant-contrib/1.0b3/ant-contrib-1.0b3.jar"}
