#
# Authors:: Benjamin Black (<b@b3k.us>) and Sean Cribbs (<sean@basho.com>)
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

case node[:platform]

when "debian","ubuntu"
  default.riak.core.platform_lib_dir = "/usr/lib/riak"
when "redhat","centos","scientific","fedora","suse"
  if node[:kernel][:machine] == 'x86_64'
    default.riak.core.platform_lib_dir = "/usr/lib64/riak"
  else 
    default.riak.core.platform_lib_dir = "/usr/lib/riak"
  end
else
  default.riak.core.platform_lib_dir = "/usr/lib/riak"
end

default.riak.core.http = [["127.0.0.1",8098]]
default.riak.core.ring_state_dir = "/var/lib/riak/ring"
default.riak.core.handoff_port = 8099
default.riak.core.cluster_name = "default"
default.riak.core.platform_bin_dir = "/usr/sbin"
default.riak.core.platform_etc_dir = "/etc/riak"
default.riak.core.platform_data_dir = "/var/lib/riak"
