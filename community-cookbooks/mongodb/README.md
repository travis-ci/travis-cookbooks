# MongoDB Cookbook

Installs and configures MongoDB, supporting:

* Single MongoDB instance
* Replication
* Sharding
* Replication and Sharding
* 10gen repository package installation
* 10gen MongoDB Monitoring System

[![Build Status](https://travis-ci.org/edelight/chef-mongodb.png?branch=master)](https://travis-ci.org/edelight/chef-mongodb)

## REQUIREMENTS:

This cookbook depends on these external cookbooks

- apt
- python
- runit
- yum

As of 0.16 This Cookbook requires

- Chef > 11
- Ruby > 1.9

### Platform:

Currently we 'actively' test using test-kitchen on Ubuntu, Debian, CentOS, Redhat

## DEFINITIONS:

This cookbook contains a definition `mongodb_instance` which can be used to configure
a certain type of mongodb instance, like the default mongodb or various components
of a sharded setup.

For examples see the USAGE section below.

## ATTRIBUTES:

### Mongodb Configuration

Basically all settings defined in the Configuration File Options documentation page can be added to the `node['mongodb']['config'][<setting>]` attribute: http://docs.mongodb.org/manual/reference/configuration-options/

* `node['mongodb']['config']['dbpath']` - Location for mongodb data directory, defaults to "/var/lib/mongodb"
* `node['mongodb']['config']['logpath']` - Path for the logfiles, default is "/var/log/mongodb/mongodb.log"
* `node['mongodb']['config']['port']` - Port the mongod listens on, default is 27017
* `node['mongodb']['config']['rest']` - Enable the ReST interface of the webserver
* `node['mongodb']['config']['smallfiles']` - Modify MongoDB to use a smaller default data file size
* `node['mongodb']['config']['oplogsize']` - Specifies a maximum size in megabytes for the replication operation log
* `node['mongodb']['config']['bind_ip']` - Configure from which address to accept connections
* `node['mongodb']['config'][<setting>]` - General MongoDB Configuration File option

### Cookbook specific attributes

* `node[:mongodb][:reload_action]` - Action to take when MongoDB conf files are
    modified, default is `"restart"`
* `node[:mongodb][:package_version]` - Version of the MongoDB package to install, default is nil
* `node[:mongodb][:client_role]` - Role identifying all external clients which should have access to a mongod instance

### Sharding and replication attributes

* `node['mongodb']['config']['replSet']` - Define name of replicaset
* `node[:mongodb][:cluster_name]` - Name of the cluster, all members of the cluster must
    reference to the same name, as this name is used internally to identify all
    members of a cluster.
* `node[:mongodb][:shard_name]` - Name of a shard, default is "default"
* `node['mongodb']['sharded_collections']` - Define which collections are sharded
* `node[:mongodb][:replica_arbiter_only]` - Set to true to make node an [arbiter](http://docs.mongodb.org/manual/reference/replica-configuration/#local.system.replset.members[n].arbiterOnly).
* `node[:mongodb][:replica_build_indexes]` - Set to false to omit [index creation](http://docs.mongodb.org/manual/reference/replica-configuration/#local.system.replset.members[n].buildIndexes).
* `node[:mongodb][:replica_hidden]` - Set to true to [hide](http://docs.mongodb.org/manual/reference/replica-configuration/#local.system.replset.members[n].hidden) node from replicaset.
* `node[:mongodb][:replica_slave_delay]` - Number of seconds to [delay slave replication](http://docs.mongodb.org/manual/reference/replica-configuration/#local.system.replset.members[n].slaveDelay).
* `node[:mongodb][:replica_priority]` - Node [priority](http://docs.mongodb.org/manual/reference/replica-configuration/#local.system.replset.members[n].priority).
* `node[:mongodb][:replica_tags]` - Node [tags](http://docs.mongodb.org/manual/reference/replica-configuration/#local.system.replset.members[n].tags).
* `node[:mongodb][:replica_votes]` - Number of [votes](http://docs.mongodb.org/manual/reference/replica-configuration/#local.system.replset.members[n].votes) node will cast in an election.


### shared MMS Agent attributes

* `node['mongodb']['mms_agent']['api_key']` - MMS Agent API Key. No default, required.
* `node['mongodb['mms_agent']['monitoring']['version']` - Version of the MongoDB MMS Monitoring Agent package to download and install. Default is '2.0.0.17-1', required.
* `node['mongodb['mms_agent']['monitoring'][<setting>]` - General MongoDB MMS Monitoring Agent configuration file option.
* `node['mongodb['mms_agent']['backup']['version']` - Version of the MongoDB MMS Backup Agent package to download and install. Default is '1.4.3.28-1', required.
* `node['mongodb['mms_agent']['backup'][<setting>]` - General MongoDB MMS Monitoring Agent configuration file option.

### User management attributes

* `node['mongodb']['config']['auth']` - Require authentication to access or modify the database
* `node['mongodb']['admin']` - The admin user with userAdmin privileges that allows user management
* `node['mongodb']['users']` - Array of users to add when running the user management recipe

#### Monitoring Agent Settings

The defaults values installed by the package are:

```
mmsBaseUrl=https://mms.mongodb.com
configCollectionsEnabled=true
configDatabasesEnabled=true
throttlePassesShardChunkCounts = 10
throttlePassesDbstats = 20
throttlePassesOplog = 10
disableProfileDataCollection=false
disableGetLogsDataCollection=false
disableLocksAndRecordStatsDataCollection=false
enableMunin=true
useSslForAllConnections=false
sslRequireValidServerCertificates=false
```

#### Backup Agent Settings

The defaults values installed by the package are:

```
mothership=api-backup.mongodb.com
https=true
sslRequireValidServerCertificates=false
```

## USAGE:

### 10gen
Adds the stable [10gen repo](http://www.mongodb.org/downloads#packages) for the
corresponding platform. Currently only implemented for the Debian and Ubuntu repository.

Usage: just add `recipe[mongodb::10gen_repo]` to the node run_list *before* any other
MongoDB recipe, and the mongodb-10gen **stable** packages will be installed instead of the distribution default.

### Single mongodb instance

Simply add

```ruby
include_recipe "mongodb::default"
```

to your recipe. This will run the mongodb instance as configured by your distribution.
You can change the dbpath, logpath and port settings (see ATTRIBUTES) for this node by
using the `mongodb_instance` definition:

```ruby
mongodb_instance "mongodb" do
  port node['application']['port']
end
```

This definition also allows you to run another mongod instance with a different
name on the same node

```ruby
mongodb_instance "my_instance" do
  port node['mongodb']['port'] + 100
  dbpath "/data/"
end
```

The result is a new system service with

```shell
  /etc/init.d/my_instance <start|stop|restart|status>
```

### Replicasets

Add `mongodb::replicaset` (instead of `mongodb::default`) to the node's run_list. Also choose a name for your
replicaset cluster and set the value of `node[:mongodb][:cluster_name]` for each
member to this name.

### Sharding

You need a few more components, but the idea is the same: identification of the
members with their different internal roles (mongos, configserver, etc.) is done via
the `node[:mongodb][:cluster_name]` and `node[:mongodb][:shard_name]` attributes.

Let's have a look at a simple sharding setup, consisting of two shard servers, one
config server and one mongos.

First we would like to configure the two shards. For doing so, just use
`mongodb::shard` in the node's run_list and define a unique `mongodb[:shard_name]`
for each of these two nodes, say "shard1" and "shard2".

Then configure a node to act as a config server - by using the `mongodb::configserver`
recipe.

And finally you need to configure the mongos. This can be done by using the
`mongodb::mongos` recipe. The mongos needs some special configuration, as these
mongos are actually doing the configuration of the whole sharded cluster.
Most importantly you need to define what collections should be sharded by setting the
attribute `mongodb[:sharded_collections]`:

```ruby
{
  "mongodb": {
    "sharded_collections": {
      "test.addressbook": "name",
      "mydatabase.calendar": "date"
    }
  }
}
```

Now mongos will automatically enable sharding for the "test" and the "mydatabase"
database. Also the "addressbook" and the "calendar" collection will be sharded,
with sharding key "name" resp. "date".
In the context of a sharding cluster always keep in mind to use a single role
which is added to all members of the cluster to identify all member nodes.
Also shard names are important to distinguish the different shards.
This is esp. important when you want to replicate shards.

### Sharding + Replication

The setup is not much different to the one described above. All you have to do is add the
`mongodb::replicaset` recipe to all shard nodes, and make sure that all shard
nodes which should be in the same replicaset have the same shard name.

For more details, you can find a [tutorial for Sharding + Replication](https://github.com/edelight/chef-mongodb/wiki/MongoDB%3A-Replication%2BSharding) in the wiki.

### MMS Agent

This cookbook also includes support for
[MongoDB Monitoring System (MMS)](https://mms.mongodb.com/)
agent. MMS is a hosted monitoring service, provided by 10gen, Inc. Once
the small python agent program is installed on the MongoDB host, it
automatically collects the metrics and uploads them to the MMS server.
The graphs of these metrics are shown on the web page. It helps a lot
for tackling MongoDB related problems, so MMS is the baseline for all
production MongoDB deployments.


To setup MMS, simply set your keys in
`node['mongodb']['mms_agent']['api_key']` and then add the
`mongodb::mms-agent` recipe to your run list. Your current keys should
be available at your [MMS Settings page](https://mms.mongodb.com/settings).

### User Management

An optional recipe is `mongodb::user_management` which will enable authentication in
the configuration file by default and create any users in the `node['mongodb']['users']`.
The users array expects a hash of username, password, roles, and database. Roles should be
an array of roles the user should have on the database given.

By default, authentication is not required on the database. This can be overridden by setting
the `node['mongodb']['config']['auth']` attribute to true in the chef json.

If the auth configuration is true, it will try to create the `node['mongodb']['admin']` user, or
update them if they already exist. Before using on a new database, ensure you're overwriting
the `node['mongodb']['admin']['username']` and `node['mongodb']['admin']['password']` to
something besides their default values.

There's also a user resource which has the actions `:add`, `:modify` and `:delete`. If modify is
used on a user that doesn't exist, it will be added. If add is used on a user that exists, it
will be modified.

# LICENSE and AUTHOR:

Author:: Markus Korn <markus.korn@edelight.de>

Copyright:: 2011-2014, edelight GmbH

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
