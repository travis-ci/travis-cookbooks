Description
===========

Chef cookbook that installs and configures the [Librato Metrics
Collectd Plugin](https://github.com/librato/collectd-librato).

Requirements
============

 * [collectd cookbook](https://github.com/librato/collectd-cookbook)

Attributes
==========

 * `node[:collectd_librato][:version]` - Version of Librato Collectd
   plugin to install. Tag must exist. (optional, defaults to latest)
 * `node[:collectd_librato][:email]` - Librato Metrics Email
 * `node[:collectd_librato][:api_token]` - Librato Metrics API Token

Usage
=====

