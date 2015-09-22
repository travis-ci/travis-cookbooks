ChefGem
=======

This cookbook is a transition cookbook aimed at helping move from the
pre-chef_gem era to the post chef_gem era. The chef_gem resource was
introducde in Chef 0.10.9, providing an easy mechanism for installing
and using gems required by Chef internally. When used within an omnibus
installation, chef_gems are installed within the embedded Ruby.

What this cookbook provides
----------------------------

For pre 0.10.9 Chef installations, it provides a chef_gem compatible resouce
allowing cookbooks to be updated but not requiring full conversions. For installations
under 0.10.12, some patches are added to aid in proper omnibus functionality allowing
chef_gem to work as expected. For Chef installations of 0.10.12 and beyond, this
cookbook provides nothing. This means you will get consistent and expected behavior
across Chef versions.

Configuration
-------------

Notable attributes (note that these should only be required for special cases):

* `node[:gem_binary] = '/usr/local/bin/gem'`
* `node[:chef_gem_binary] = '/opt/opscode/embedded/bin/gem'`

Notes
-----

With the release of 0.10.12 this cookbook should be considered deprecated and used
only for compatibility with older installations.

Repository
----------

* https://github.com/hw-cookbooks/chef_gem
* IRC: Freenode @ #heavywater