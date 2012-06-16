#
# Author:: Sean Cribbs (<sean@basho.com>)
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

# package.rb
if (node.riak.package.type.eql?("source"))
  node.default.riak.package.prefix = "/usr/local"
  node.default.riak.package.config_dir = node.riak.package.prefix + "/riak/etc"
end

# erlang.rb
node.default.riak.erlang.node_name = "riak@#{node.ipaddress}"

# core.rb
# Make sure the bare minimums are set so the cluster works
if node.riak.core.to_hash['default_bucket_props'].is_a?(Mash)
  node.default.riak.core.default_bucket_props.n_val = 3
  node.default.riak.core.default_bucket_props.chash_keyfun = [:riak_core_util, :chash_std_keyfun]
end

# kernel.rb
unless node.riak.kernel.limit_port_range
  node.riak.kernel.delete(:inet_dist_listen_min)
  node.riak.kernel.delete(:inet_dist_listen_max)
end


# kv.rb
node.riak.kv.storage_backend = (node.riak.kv.storage_backend).to_s.to_sym

# sasl.rb
node.riak.sasl.errlog_type = (node.riak.sasl.errlog_type).to_s.to_sym


case node.riak.kv.storage_backend
when :riak_kv_bitcask_backend # bitcask.rb
  node.riak.delete(:eleveldb)
  node.riak.delete(:innostore)
  node.riak.kv.delete(:riak_kv_dets_backend_root)
  unless (node.riak.bitcask).to_hash["sync_strategy"].is_a?(Mash)
    node.riak.bitcask.sync_strategy = (node.riak.bitcask.sync_strategy).to_s.to_sym
  end
when :riak_kv_eleveldb_backend # eleveldb.rb
  node.riak.delete(:bitcask)
  node.riak.delete(:innostore)
  node.riak.kv.delete(:riak_kv_dets_backend_root)
when :riak_kv_dets_backend # dets.rb
  node.riak.delete(:bitcask)
  node.riak.delete(:eleveldb)
  node.riak.delete(:innostore)
when # innostore.rb
  node.riak.delete(:bitcask)
  node.riak.delete(:eleveldb)
  node.riak.kv.delete(:riak_kv_dets_backend_root)
end
