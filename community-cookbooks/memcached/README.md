memcached Cookbook
==================
[![Build Status](https://secure.travis-ci.org/chef-cookbooks/memcached.png?branch=master)](http://travis-ci.org/chef-cookbooks/memcached)


Installs memcached and provides a define to set up an instance of memcache via runit.


Requirements
------------
A runit service can be set up for instances using the `memcache_instance` definition.

### Platforms
- Ubuntu 10.04, 12.04
- CentOS/RHEL 5.8, 6.3
- openSUSE 12.3
- SLES 12 SP2
- SmartOS base64 1.8.1 - Note that SMF directly configures memcached with no opportunity to alter settings. If you need custom parameters, use the `memcached_instance` provider instead.

May work on other systems with or without modification.

### Cookbooks
- runit
- yum
- yum-epel


Attributes
----------
The following are node attributes passed to the template for the runit service.

- `memcached['memory']` - maximum memory for memcached instances.
- `memcached['user']` - user to run memcached as.
- `memcached['port']` - TCP port for memcached to listen on.
- `memcached['udp_port']` - UDP port for memcached to listen on.
- `memcached['listen']` - IP address for memcache to listen on, defaults to **0.0.0.0** (world accessible).
- `memcached['maxconn']` - maximum number of connections to accept (defaults to 1024)
- `memcached['max_object_size']` - maximum size of an object to cache (defaults to 1MB)
- `memcached['logfilepath']` - path to directory where log file will be written.
- `memcached['logfilename']` - logfile to which memcached output will be redirected in $logfilepath/$logfilename.
- `memcached['threads']` - Number of threads to use to process incoming requests. The default is 4.
- `memcached['experimental_options']` - Comma separated list of extended or experimental options. (array)
- `memcached['ulimit']` - boolean `true` will set the ulimit to the `maxconn` value

Usage
-----
Simply set the attributes and it will configure the `/etc/memcached.conf` file. If you want to use multiple memcached instances, you'll need to modify the recipe to disable the startup script and the template in the default recipe.

Use the definition, `memcached_instance`, to set up a runit service for the named memcached instance. (If the instance name is `memcached` the service name will be `memcached` otherwise it will be `memcached-#{service_name}`)

```
memcached_instance 'myproj'
```

The recipe also reads in whether to start up memcached from a `/etc/default/memcached` "ENABLE_MEMCACHED" setting, which is "yes" by default.


License & Authors
-----------------
- Author:: Joshua Timberman (<joshua@chef.io>)
- Author:: Joshua Sierles (<joshua@37signals.com>)

```text
Copyright:: 2009-2012, Chef Software, Inc
Copyright:: 2009, 37signals

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
