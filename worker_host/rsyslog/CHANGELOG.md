## v1.3.0:

* [COOK-1189] - template change does not restart rsyslog on Ubuntu

This actually went into 1.2.0 with action `:reload`, but that change
has been reverted and the action is back to `:restart`.

## v1.2.0:

* [COOK-1678] - syslog user does not exist on debian 6.0 and ubuntu
  versions lower than 11.04
* [COOK-1650] - enable max message size configuration via attribute

## v1.1.0:

Changes from COOK-1167:

* More versatile server discovery - use the IP as an attribute, or use
  search (see README)
* Removed cron dependency.
* Removed log archival; logrotate is recommended.
* Add an attribute to select the per-host directory in the log dir
* Works with Chef Solo now.
* Set debian/ubuntu default user and group. Drop privileges to `syslog.adm`.


## v1.0.0:

* [COOK-836] - use an attribute to specify the role to search for
  instead of relying on the rsyslog['server'] attribute.
* Clean up attribute usage to use strings instead of symbols.
* Update this README.
* Better handling for chef-solo.
