Riak Cookbook
=============

Overview
========

Riak is a Dynamo-inspired key/value store that scales predictably and easily.  Riak combines a decentralized key/value store, a flexible map/reduce engine, and a friendly HTTP/JSON query interface to provide a database ideally suited for Web applications. And, without any object-relational mappers and other heavy middleware, applications built on Riak can be both simpler and more powerful.  For complete documentation and source code, see the Riak home page at [Basho][1].


Getting Started
===============

The Riak cookbook can be used just by adding "riak" to the runlist for a node.  The default settings will cause Riak to be installed and configured.  Creating a cluster of nodes requires you set appropriate attributes, particularly the Erlang `node_name`, and either manually join nodes to the cluster or use the gossip seed configuration option.


Package Installation
--------------------

There are two options for package installation: source and binary.  If you are using a RedHat or Debian/Ubuntu system, binary installation is recommended and is the default.  If you choose to do a source installation, be sure you are using Erlang/OTP R14B02 or later.

The package parameters available are version, type and, optionally for source installation, an install prefix:

	node[:riak][:package][:version][:major] = "0"
	node[:riak][:package][:version][:minor] = "11"
	node[:riak][:package][:version][:incremental] = "0"
	node[:riak][:package][:type] = ("binary" | "source")
	node[:riak][:package][:prefix] = "/usr/local"


Basic Configuration
-------------------

Most Riak configuration is for networking, Erlang, and storage backends.  The only, interesting configuration options outside of those is the filesystem path where ring state files should be stored.

	node[:riak][:core][:ring_state_dir] = "/var/lib/riak/ring"


Networking
----------

Riak clients communicate with the nodes in the cluster through either the HTTP or Protobufs interfaces, both of which may be used simultaneously.  Configuration for each interface includes the IP address and TCP port on which to listen for client connections.  The default for the HTTP interface is localhost:8098 and for Protobufs 0.0.0.0:8087, meaning client connections to any address on the server, TCP port 8087, are accepted.  As the default HTTP configuration is inaccessible to other nodes, it must be changed if you want clients to use the HTTP interface.

	node[:riak][:core][:http] = [["127.0.0.1", 8098]]
	node[:riak][:kv][:pb_ip] = "0.0.0.0"
	node[:riak][:kv][:pb_port] = 8087

Intra-cluster handoff occurs over a dedicated port, which defaults to 8099.

	node[:riak][:core][:handoff_port] = 8099

Finally, by default, options are included in the configuration to define the set of ports used for Erlang inter-node communication.  

	node[:riak][:kernel][:limit_port_range] = true
	node[:riak][:kernel][:inet_dist_listen_min] = 6000
	node[:riak][:kernel][:inet_dist_listen_max] = 7999

On Debian/Ubuntu platforms, IPTables rules corresponding to these settings to explicitly allow required ports and addresses are automatically generated.


Erlang
------

A number of Erlang parameters may be configured through the cookbook.  The node name and cookie are most important for creating multi-node clusters.  The rest of the parameters are primarily for performance tuning, with kernel polling and smp enabled by default.  Any available Erlang environment variable may be set with the env vars hash. 

	node[:riak][:erlang][:node_name] = "riak@#{node[:fqdn]}"
	node[:riak][:erlang][:cookie] = "riak"
	node[:riak][:erlang][:kernel_polling] = (true | false)
	node[:riak][:erlang][:async_threads] = 64
	node[:riak][:erlang][:smp] = ("enable" | "disable")
	node[:riak][:erlang][:env_vars][:ERL_MAX_PORTS] = 4096
    node[:riak][:erlang][:env_vars][:ERL_FULLSWEEP_AFTER] = 10


Storage Backends
================

Riak requires specification of a storage backend along with various backend storage options, specific to each backend.  While Riak supports specification of different backends for different buckets, the Chef cookbook does not yet allow such configurations.  The most common backends are Bitcask (the default), Innostore, and DETS.  The typical configuration options and their defaults are given below.


Bitcask
-------

By virtue of its architecture, Bitcask requires much less tuning to achieve good performance than Innostore.

	node[:riak][:bitcask][:data_root] = "/var/lib/riak/bitcask"
	node[:riak][:bitcask][:max_file_size] = 2147483648
	node[:riak][:bitcask][:open_timeout] = 4
	node[:riak][:bitcask][:sync_strategy] = :none
	node[:riak][:bitcask][:frag_merge_trigger] = 60
	node[:riak][:bitcask][:dead_bytes_merge_trigger] = 536870912
	node[:riak][:bitcask][:frag_threshold] = 40
	node[:riak][:bitcask][:dead_bytes_threshold] = 134217728
	node[:riak][:bitcask][:small_file_threshold] = 10485760
	node[:riak][:bitcask][:expiry_secs] = -1


DETS
----

DETS is the default storage backend for Riak.  It's very simple to setup, only requiring a path where it should store data files.  However, for production use Innostore and Bitcask are better choices.

	node[:riak][:kv][:riak_kv_dets_backend_root] = "/var/lib/riak/dets"

eLevelDB
--------

driver based on google leveldb. see http://wiki.basho.com/LevelDB.html
for more info. currently only setting the root dir is supported. if
you want support for more options, just add it in attributes/eleveldb.rb

	node[:riak][:kv][:riak_kv_eleveldb_backend_root] = "/var/lib/riak/leveldb"

Innostore
---------

Innostore is an Erlang wrapper around embedded InnoDB, a transactional storage engine developed for and generally used with MySQL.  It has an enormous set of tuning parameters, all of which are documented at the [InnoDB site][2].  The most common parameters are set to reasonable defaults by the Riak cookbook.

	node[:riak][:innostore][:log_buffer_size] = 8388608
	node[:riak][:innostore][:log_files_in_group] = 8
	node[:riak][:innostore][:log_file_size] = 268435456
	node[:riak][:innostore][:flush_log_at_trx_commit] = 1
	node[:riak][:innostore][:data_home_dir] = "/var/lib/riak/innodb"
	node[:riak][:innostore][:log_group_home_dir] = "/var/lib/riak/innodb"
	node[:riak][:innostore][:buffer_pool_size] = 2147483648

Lager 
-----

[Lager][3] is the logging framework used within Riak. It can also be used with erlang/OTP. 


    node[:riak][:lager][:handlers][:lager_console_backend]= :info
	node[:riak][:lager][:crash_log] = "/var/log/riak/crash.log"
	node[:riak][:lager][:crash_log_date] = "$D0"
	node[:riak][:lager][:crash_log_msg_size]  = 65536
	node[:riak][:lager][:crash_log_size] = 10485760
	node[:riak][:lager][:error_logger_redirect] = true
	node[:riak][:lager][:handlers][:lager_file_backend][:lager_error_log] =  ["/var/log/riak/error.log", :error, 10485760, "$D0", 5]
	node[:riak][:lager][:handlers][:lager_file_backend][:lager_console_log] = ["/var/log/riak/console.log", :info, 10485760, "$D0", 5]

Sysmon 
------

Sysmon monitors riaks gc process and logs relevant information to the status of garbage collection.

	node[:riak][:sysmon][:process_limit] = 30
	node[:riak][:sysmon][:port_limit] = 30
	node[:riak][:sysmon][:gc_ms_limit] = 50 #if gc takes longer than 50ms. Spam the log. 
	node[:riak][:sysmon][:heap_word_limit] = 10485760
	
Index Merge
-----------
	node[:riak][:merge_index][:data_root] = "/var/lib/riak/merge_index"
	node[:riak][:merge_index][:data_root_2i] = "/var/lib/riak/merge_index_2i"
	node[:riak][:merge_index][:buffer_rollover_size] = 1048576
	node[:riak][:merge_index][:max_compact_segments] = 20
	

[1]: http://basho.com/
[2]: http://www.innodb.com/doc/embedded_innodb-1.0/#config-vars
[3]: https://github.com/basho/lager