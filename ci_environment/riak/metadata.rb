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

maintainer        "Basho Technologies, Inc."
maintainer_email  "riak@basho.com"
license           "Apache 2.0"
description       "Installs and configures Riak distributed data store"
version           "1.2.0"
recipe            "riak", "Installs Riak"
recipe            "riak::autoconf", "Automatically configure nodes from chef-server information."
recipe            "riak::innostore", "Install and configure the Innostore backend."
recipe            "riak::iptables", "Automatically configure iptables rules for Riak."

%w{ubuntu debian centos redhat suse fedora}.each do |os|
  supports os
end
