Description
===========

Installs libevent (from source)

Requirements
============

## Platform

* Linux (I'd tested on CentOS 6.3)

Attributes
==========

* `node['libevent']['version']` - version of libev. Default is 2.0.20 .
* `node['libevent']['prefix']`  - prefix of install_path. Default is /usr .

Usage
=====

Simply include the `libevent` and the libevent will be installed to your system.
