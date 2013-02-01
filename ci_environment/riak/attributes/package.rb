#
# Author:: Benjamin Black (<b@b3k.us>) and Sean Cribbs (<sean@basho.com>)
# Cookbook Name:: riak
#
# Copyright (c) 2011 Basho Technologies, Inc.
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

default.riak.package.type = "binary"
if !(node.kernel.machine == "x86_64")
  # the only 32 bit package of 1.2.0. MK.
  default.riak.package.url  = "http://s3.amazonaws.com/downloads.basho.com/riak/1.2/1.2.1/ubuntu/lucid/riak_1.2.1-1_i386.deb"
end
default.riak.package.version.major = "1"
default.riak.package.version.minor = "2"
default.riak.package.version.incremental = "1"
default.riak.package.version.build = "1"
default.riak.package.source_checksum = '009e9ceb83f7653dfc26ce71220b183e61d8b3e3'
default.riak.package.config_dir = "/etc/riak"
