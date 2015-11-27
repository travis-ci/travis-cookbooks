#
# Cookbook Name:: mongodb
# Definition:: mongodb
#
# Copyright 2011, edelight GmbH
# Authors:
#       Markus Korn <markus.korn@edelight.de>
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

require 'json'

class Chef::ResourceDefinitionList::MongoDB
  def self.configure_replicaset(node, name, members)
    # lazy require, to move loading this modules to runtime of the cookbook
    require 'rubygems'
    require 'mongo'

    if members.length == 0
      if Chef::Config[:solo]
        Chef::Log.warn('Cannot search for member nodes with chef-solo, defaulting to single node replica set')
      else
        Chef::Log.warn("Cannot configure replicaset '#{name}', no member nodes found")
        return
      end
    end

    begin
      connection = nil
      rescue_connection_failure do
        connection = Mongo::Connection.new('localhost', node['mongodb']['config']['port'], :op_timeout => 5, :slave_ok => true)
        connection.database_names # check connection
      end
    rescue => e
      Chef::Log.warn("Could not connect to database: 'localhost:#{node['mongodb']['config']['port']}', reason: #{e}")
      return
    end

    # Want the node originating the connection to be included in the replicaset
    members << node unless members.any? { |m| m.name == node.name }
    members.sort! { |x, y| x.name <=> y.name }
    rs_members = []
    rs_options = {}
    members.each_index do |n|
      host = "#{members[n]['fqdn']}:#{members[n]['mongodb']['config']['port']}"
      rs_options[host] = {}
      rs_options[host]['arbiterOnly'] = true if members[n]['mongodb']['replica_arbiter_only']
      rs_options[host]['buildIndexes'] = false unless members[n]['mongodb']['replica_build_indexes']
      rs_options[host]['hidden'] = true if members[n]['mongodb']['replica_hidden']
      slave_delay = members[n]['mongodb']['replica_slave_delay']
      rs_options[host]['slaveDelay'] = slave_delay if slave_delay > 0
      if rs_options[host]['buildIndexes'] == false || rs_options[host]['hidden'] || rs_options[host]['slaveDelay']
        priority = 0
      else
        priority = members[n]['mongodb']['replica_priority']
      end
      rs_options[host]['priority'] = priority unless priority == 1
      tags = members[n]['mongodb']['replica_tags'].to_hash
      rs_options[host]['tags'] = tags unless tags.empty?
      votes = members[n]['mongodb']['replica_votes']
      rs_options[host]['votes'] = votes unless votes == 1
      rs_members << { '_id' => n, 'host' => host }.merge(rs_options[host])
    end

    Chef::Log.info(
      "Configuring replicaset with members #{members.map { |n| n['hostname'] }.join(', ')}"
    )

    rs_member_ips = []
    members.each_index do |n|
      port = members[n]['mongodb']['config']['port']
      rs_member_ips << { '_id' => n, 'host' => "#{members[n]['ipaddress']}:#{port}" }
    end

    admin = connection['admin']
    cmd = BSON::OrderedHash.new
    cmd['replSetInitiate'] = {
      '_id' => name,
      'members' => rs_members
    }

    begin
      result = admin.command(cmd, :check_response => false)
    rescue Mongo::OperationTimeout
      Chef::Log.info('Started configuring the replicaset, this will take some time, another run should run smoothly')
      return
    end
    if result.fetch('ok', nil) == 1
      # everything is fine, do nothing
    elsif result.fetch('errmsg', nil) =~ /(\S+) is already initiated/ || (result.fetch('errmsg', nil) == 'already initialized')
      server, port = Regexp.last_match.nil? || Regexp.last_match.length < 2 ? ['localhost', node['mongodb']['config']['port']] : Regexp.last_match[1].split(':')
      begin
        connection = Mongo::Connection.new(server, port, :op_timeout => 5, :slave_ok => true)
      rescue
        abort("Could not connect to database: '#{server}:#{port}'")
      end

      # check if both configs are the same
      config = connection['local']['system']['replset'].find_one('_id' => name)

      if config['_id'] == name && config['members'] == rs_members
        # config is up-to-date, do nothing
        Chef::Log.info("Replicaset '#{name}' already configured")
      elsif config['_id'] == name && config['members'] == rs_member_ips
        # config is up-to-date, but ips are used instead of hostnames, change config to hostnames
        Chef::Log.info("Need to convert ips to hostnames for replicaset '#{name}'")
        old_members = config['members'].map { |m| m['host'] }
        mapping = {}
        rs_member_ips.each do |mem_h|
          members.each do |n|
            ip, prt = mem_h['host'].split(':')
            mapping["#{ip}:#{prt}"] = "#{n['fqdn']}:#{prt}" if ip == n['ipaddress']
          end
        end
        config['members'].map! do |m|
          host = mapping[m['host']]
          { '_id' => m['_id'], 'host' => host }.merge(rs_options[host])
        end
        config['version'] += 1

        rs_connection = nil
        rescue_connection_failure do
          rs_connection = Mongo::ReplSetConnection.new(old_members)
          rs_connection.database_names # check connection
        end

        admin = rs_connection['admin']
        cmd = BSON::OrderedHash.new
        cmd['replSetReconfig'] = config
        result = nil
        begin
          result = admin.command(cmd, :check_response => false)
        rescue Mongo::ConnectionFailure
          # reconfiguring destroys existing connections, reconnect
          connection = Mongo::Connection.new('localhost', node['mongodb']['config']['port'], :op_timeout => 5, :slave_ok => true)
          config = connection['local']['system']['replset'].find_one('_id' => name)
          # Validate configuration change
          if config['members'] == rs_members
            Chef::Log.info("New config successfully applied: #{config.inspect}")
          else
            Chef::Log.error("Failed to apply new config. Current config: #{config.inspect} Target config #{rs_members}")
            return
          end
        end
        Chef::Log.error("configuring replicaset returned: #{result.inspect}") unless result.fetch('errmsg', nil).nil?
      else
        # remove removed members from the replicaset and add the new ones
        max_id = config['members'].map { |member| member['_id'] }.max
        rs_members.map! { |member| member['host'] }
        config['version'] += 1
        old_members = config['members'].map { |member| member['host'] }
        members_delete = old_members - rs_members
        config['members'] = config['members'].delete_if { |m| members_delete.include?(m['host']) }
        config['members'].map! do |m|
          host = m['host']
          { '_id' => m['_id'], 'host' => host }.merge(rs_options[host])
        end
        members_add = rs_members - old_members
        members_add.each do |m|
          max_id += 1
          config['members'] << { '_id' => max_id, 'host' => m }.merge(rs_options[m])
        end

        rs_connection = nil
        rescue_connection_failure do
          rs_connection = Mongo::ReplSetConnection.new(old_members)
          rs_connection.database_names # check connection
        end

        admin = rs_connection['admin']

        cmd = BSON::OrderedHash.new
        cmd['replSetReconfig'] = config

        result = nil
        begin
          result = admin.command(cmd, :check_response => false)
        rescue Mongo::ConnectionFailure
          # reconfiguring destroys existing connections, reconnect
          connection = Mongo::Connection.new('localhost', node['mongodb']['config']['port'], :op_timeout => 5, :slave_ok => true)
          config = connection['local']['system']['replset'].find_one('_id' => name)
          # Validate configuration change
          if config['members'] == rs_members
            Chef::Log.info("New config successfully applied: #{config.inspect}")
          else
            Chef::Log.error("Failed to apply new config. Current config: #{config.inspect} Target config #{rs_members}")
            return
          end
        end
        Chef::Log.error("configuring replicaset returned: #{result.inspect}") unless result.nil? || result.fetch('errmsg', nil).nil?
      end
    elsif !result.fetch('errmsg', nil).nil?
      Chef::Log.error("Failed to configure replicaset, reason: #{result.inspect}")
    end
  end

  def self.configure_shards(node, shard_nodes)
    # lazy require, to move loading this modules to runtime of the cookbook
    require 'rubygems'
    require 'mongo'

    shard_groups = Hash.new { |h, k| h[k] = [] }

    shard_nodes.each do |n|
      if n['recipes'].include?('mongodb::replicaset')
        # do not include hidden members when calling addShard
        # see https://jira.mongodb.org/browse/SERVER-9882
        next if n['mongodb']['replica_hidden']
        key = "rs_#{n['mongodb']['shard_name']}"
      else
        key = '_single'
      end
      shard_groups[key] << "#{n['fqdn']}:#{n['mongodb']['config']['port']}"
    end
    Chef::Log.info(shard_groups.inspect)

    shard_members = []
    shard_groups.each do |name, members|
      if name == '_single'
        shard_members += members
      else
        shard_members << "#{name}/#{members.join(',')}"
      end
    end
    Chef::Log.info(shard_members.inspect)

    begin
      connection = Mongo::Connection.new('localhost', node['mongodb']['config']['port'], :op_timeout => 5)
    rescue => e
      Chef::Log.warn("Could not connect to database: 'localhost:#{node['mongodb']['config']['port']}', reason #{e}")
      return
    end

    admin = connection['admin']

    shard_members.each do |shard|
      cmd = BSON::OrderedHash.new
      cmd['addShard'] = shard
      begin
        result = admin.command(cmd, :check_response => false)
      rescue Mongo::OperationTimeout
        result = "Adding shard '#{shard}' timed out, run the recipe again to check the result"
      end
      Chef::Log.info(result.inspect)
    end
  end

  def self.configure_sharded_collections(node, sharded_collections)
    if sharded_collections.nil? || sharded_collections.empty?
      Chef::Log.warn('No sharded collections configured, doing nothing')
      return
    end

    # lazy require, to move loading this modules to runtime of the cookbook
    require 'rubygems'
    require 'mongo'

    begin
      connection = Mongo::Connection.new('localhost', node['mongodb']['config']['port'], :op_timeout => 5)
    rescue => e
      Chef::Log.warn("Could not connect to database: 'localhost:#{node['mongodb']['config']['port']}', reason #{e}")
      return
    end

    admin = connection['admin']

    databases = sharded_collections.keys.map { |x| x.split('.').first }.uniq
    Chef::Log.info("enable sharding for these databases: '#{databases.inspect}'")

    databases.each do |db_name|
      cmd = BSON::OrderedHash.new
      cmd['enablesharding'] = db_name
      begin
        result = admin.command(cmd, :check_response => false)
      rescue Mongo::OperationTimeout
        result = "enable sharding for '#{db_name}' timed out, run the recipe again to check the result"
      end
      if result['ok'] == 0
        # some error
        errmsg = result.fetch('errmsg')
        if errmsg == 'already enabled'
          Chef::Log.info("Sharding is already enabled for database '#{db_name}', doing nothing")
        else
          Chef::Log.error("Failed to enable sharding for database #{db_name}, result was: #{result.inspect}")
        end
      else
        # success
        Chef::Log.info("Enabled sharding for database '#{db_name}'")
      end
    end

    sharded_collections.each do |name, key|
      cmd = BSON::OrderedHash.new
      cmd['shardcollection'] = name
      cmd['key'] = { key => 1 }
      begin
        result = admin.command(cmd, :check_response => false)
      rescue Mongo::OperationTimeout
        result = "sharding '#{name}' on key '#{key}' timed out, run the recipe again to check the result"
      end
      if result['ok'] == 0
        # some error
        errmsg = result.fetch('errmsg')
        if errmsg == 'already sharded'
          Chef::Log.info("Sharding is already configured for collection '#{name}', doing nothing")
        else
          Chef::Log.error("Failed to shard collection #{name}, result was: #{result.inspect}")
        end
      else
        # success
        Chef::Log.info("Sharding for collection '#{result['collectionsharded']}' enabled")
      end
    end
  end

  # Ensure retry upon failure
  def self.rescue_connection_failure(max_retries = 30)
    retries = 0
    begin
      yield
    rescue Mongo::ConnectionFailure => ex
      retries += 1
      raise ex if retries > max_retries
      sleep(0.5)
      retry
    end
  end
end
