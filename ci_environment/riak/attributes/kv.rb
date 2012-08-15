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

default.riak.kv.mapred_queue_dir = "/var/lib/riak/mr_queue"
default.riak.kv.mapred_name = "mapred"
default.riak.kv.mapred_system = :pipe
default.riak.kv.mapred_2i_pipe = true
default.riak.kv.map_js_vm_count = 8
default.riak.kv.reduce_js_vm_count = 6
default.riak.kv.hook_js_vm_count = 2
default.riak.kv.js_max_vm_mem = 8
default.riak.kv.js_thread_stack = 16
default.riak.kv.http_url_encoding = "on"
default.riak.kv.raw_name = "riak"
default.riak.kv.vnode_vclocks = true
default.riak.kv.legacy_keylisting = false

# +-------------------------+
# | Standard Single Backend |
# +-------------------------+
#
default.riak.kv.storage_backend = :riak_kv_eleveldb_backend

# +-------------------------+
# |  Multi Backend for CS   |
# +-------------------------+

#default.riak.kv.storage_backend = :riak_cs_kv_multi_backend
#default.riak.kv.multi_backend_prefix_list = {:"<<\"0b:\">>" => :be_blocks}
#default.riak.kv.multi_backend_default = :be_default

#default.riak.kv.multi_backend.backend1 = [:be_default, :riak_kv_eleveldb_backend, {:max_open_files => 50,:data_root => "/var/lib/riak/leveldb"} ]
#default.riak.kv.multi_backend.backend2 = [:be_blocks, :riak_kv_bitcask_backend,   {:data_root => "/var/lib/riak/bitcask"} ]

# +-------------------------+
# |  Multi Backend NOT CS   |
# +-------------------------+
#
#default.riak.kv.storage_backend = :riak_kv_multi_backend
#default.riak.kv.multi_backend_default = :"<<\"bitcask_mult\">>"

## format:                    .anyname  = [         name                   ,           module          ,               [Configs]                 ]
#default.riak.kv.multi_backend.backend1 = [:"<<\"bitcask_mult\">>"         , :riak_kv_bitcask_backend  , {:data_root => "/var/lib/riak/bitcask"} ]
#default.riak.kv.multi_backend.backend2 = [:"<<\"eleveldb_mult\">>"        , :riak_kv_eleveldb_backend , {:max_open_files => 50, :data_root => "/var/lib/riak/leveldb"} ]
#default.riak.kv.multi_backend.backend3 = [:"<<\"second_eleveldb_mult\">>" , :riak_kv_eleveldb_backend , {:max_open_files => 35, :data_root => "/var/lib/riak/leveldb"} ]
#default.riak.kv.multi_backend.backend4 = [:"<<\"memory_mult\">>"          , :riak_kv_memory_backend   , {:max_memory => 4096, :ttl => 86400} ]
