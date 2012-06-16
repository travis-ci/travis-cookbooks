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
require 'delegate'
module RiakTemplateHelper
  class Tuple < DelegateClass(Array)
    include RiakTemplateHelper
    def to_s(depth=1)
      "{" << map {|i| value_to_erlang(i,depth) }.join(", ") << "}"
    end
  end

  def value_to_erlang(v, depth=1)
    case v
    when Hash
      to_erlang_config(v, depth+1)
    when String
      "\"#{v}\""
    when Array
      "[" << v.map {|i| value_to_erlang(i) }.join(", ") << "]"
    else
      v.to_s
    end
  end

  # Lifted from Ripple's Riak::TestServer
  def to_erlang_config(hash, depth = 1)
    padding = '    ' * depth
    parent_padding = '    ' * (depth-1)

    # Traverse through the hash in key sorted order so that we avoid
    # any issues with the traversal order changing and forcing a Riak restart.
    values = hash.keys.sort.map do |k|
      v = hash[k]

      if KEYLESS_ATTRIBUTES.include?(k)
        #We make the assumption that all KEYLESS_ATTRIBUTES are arrays.
        Tuple.new(v).to_s(depth)
      else
        "{#{k}, #{value_to_erlang(v, depth)}}"
      end
    end.join(",\n#{padding}")
    "[\n#{padding}#{values}\n#{parent_padding}]"
  end

  #There are several configurations that are not key/value. They should be added to KEYLESS_ATTRIBUTES.
  #A sample of this wold be the lager configuration.
  #{"{{platform_log_dir}}/error.log", error, 10485760, "$D0", 5}
  KEYLESS_ATTRIBUTES = ['lager_error_log','lager_console_log','default_user']

  #Remove these configs. This will make sure package and erlang vms are not processed into the riak app.config.
  RIAK_REMOVE_CONFIGS = ['package', 'erlang']

  RIAK_TRANSLATE_CONFIGS = {
    'core' => 'riak_core',
    'kv' => 'riak_kv',
    'search' => 'riak_search',
    'err' => 'riak_err',
    'sysmon' => 'riak_sysmon',
    'control' => 'riak_control'
  }


  def prepare_app_config(riak)

    node.riak.core.http[0][0] = node[:network][:interfaces][node.riak.net_dev_int][:addresses].select { |address, data| data[:family] == "inet" }[0][0]
    node.riak.kv.pb_ip        = node[:network][:interfaces][node.riak.net_dev_int][:addresses].select { |address, data| data[:family] == "inet" }[0][0]

    #Each backend in multi-backend will be a keyless tuple, so add them to KEYLESS_ATTRIBUTES
    riak[:kv].fetch(:multi_backend, {}).each_key { |k| KEYLESS_ATTRIBUTES.push(k) }


    # Don't muck with the node attributes
    riak = riak.to_hash

    #remove net_dev_int from app.config
    riak.delete('net_dev_int')

    # Remove sections we don't care about
    riak.reject! {|k,_| RIAK_REMOVE_CONFIGS.include? k }

    # Rename sections
    riak.dup.each do |k,v|
      next if k.nil?
      if RIAK_TRANSLATE_CONFIGS.include? k
        riak[RIAK_TRANSLATE_CONFIGS[k]] = riak.delete(k)
      end
    end

    # Only limit Erlang port range if limit_port_range is true
    if riak['kernel'] && riak['kernel']['limit_port_range']
      riak['kernel'].delete 'limit_port_range'
    else
      riak.delete 'kernel'
    end

    # Select the backend configuration
    riak['riak_kv']['storage_backend'] = riak['riak_kv']['storage_backend'].to_sym
    riak.delete('innostore') unless riak['riak_kv']['storage_backend']==:riak_kv_innostore_backend
    riak.delete('eleveldb')  unless riak['riak_kv']['storage_backend']==:riak_kv_eleveldb_backend
    riak.delete('bitcask')   unless riak['riak_kv']['storage_backend']==:riak_kv_bitcask_backend
    riak['riak_kv'].delete('riak_kv_dets_backend_root') unless riak['riak_kv']['storage_backend']==:riak_kv_dets_backend
    #This adds the multibackends in their own section of app.config for cs
    if riak['riak_kv']['storage_backend']==:riak_cs_kv_multi_backend
      node.riak.kv.multi_backend.each do |k,v|
        riak[v[1].to_s.split('_')[2]] = v[2]
      end
    end

    riak['riak_core']['default_bucket_props']['chash_keyfun'] = Tuple.new(riak['riak_core']['default_bucket_props']['chash_keyfun'].map {|i| i.to_sym }) if riak['riak_core']['default_bucket_props'] && riak['riak_core']['default_bucket_props']['chash_keyfun']

    riak['riak_core']['default_bucket_props']['linkfun'] = Tuple.new(riak['riak_core']['default_bucket_props']['linkfun'].map {|i| i.to_sym }) if riak['riak_core']['default_bucket_props'] && riak['riak_core']['default_bucket_props']['linkfun']

    allifs = lambda {|pair| pair[0] == "0.0.0.0" }
    %w{http https}.each do |protocol|
      if pairs = riak['riak_core'][protocol]
        # If there's all-interfaces bindings ("0.0.0.0"), remove any
        # specific interface bindings on the associated ports. Trying
        # to bind twice will prevent riak from starting without much
        # diagnostic information.
        if pairs.any?(&allifs)
          ports = pairs.select(&allifs).map {|pair| pair[1] }
          pairs = pairs.delete_if {|(intf, port)| ports.include?(port) && intf != "0.0.0.0" }
        end
        riak['riak_core'][protocol] = pairs.uniq.map { |pair| Tuple.new(pair) }
      end
    end

    # Return the sanitized config
    riak
  end

  RIAK_VM_ARGS = {
    "node_name" => "-name",
    "cookie" => "-setcookie",
    "heart" => "-heart",
    "kernel_polling" => "+K",
    "async_threads" => "+A",
    "error_logger_warnings" => "+W",
    "smp" => "-smp",
    "env_vars" => "-env"
  }

  def prepare_vm_args(config)
    config.keys.sort.map do |k|
      v   = config[k]
      key = RIAK_VM_ARGS[k.to_s]
      case v
      when false
        nil
      when Hash, Chef::Node::Attribute
        # Mostly for env_vars
        v.keys.sort.map { |ik| "#{key} #{ik} #{v[ik]}" }
      else
        "#{key} #{v}"
      end
    end.flatten.compact
  end
end

class Chef::Resource::Template
  include RiakTemplateHelper
end

class Erubis::Context
  include RiakTemplateHelper
end
