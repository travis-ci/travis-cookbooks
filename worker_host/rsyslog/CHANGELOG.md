rsyslog Cookbook CHANGELOG
==========================
This file is used to list changes made in each version of the rsyslog cookbook.

v.2.1.0 (2015-07-22)
----------
- Fixed minor markdown errors in the readme
- Alow the server to listen on both TCP and UDP.  For both set node['rsyslog']['protocol'] to 'udptcp'
- Move the include for /etc/rsyslog.d/ to the very end of the rsyslog.conf config
- Added the ability to bind to a specific IP when running the server on UDP with node['rsyslog']['bind']
- Sync the comments in the rsyslog.conf file with the latest upstream rsyslog release
- Change emerg to log to :omusrmsg:* vs. * on modern rsyslog releases to avoid deprecation warnings

v.2.0.0 (2015-05-18)
--------------------
Note: This version includes several breaking changes for Ubuntu users. Be sure to take care when deploying these changes to production systems.

- 49-relp.conf now properly uses the list of servers discovered in the client recipe
- Fixed a typo that prevented file-input.conf from properly templating
- Added allow_non_local attribute to allow non-local messages. This defaults to false, which preserves the previous functionality
- The rsyslog directory permissions are now properly set using the user/group attributes instead of root/root
- Properly drop permissions on Ubuntu systems to syslog/syslog.  Introduces 2 new attributes to control the user/group: priv_user and priv_group
- Remove logging to /dev/xconsole in 50-default.conf on Ubuntu systems.  This is generally not something you'd want to do and produces error messages at startup.

v.1.15.0 (2015-02-23)
---------------------
- Change minimum supported Fedora release to 20 to align with the Fedora product lifecycle
- Add supports CentOS to metadata
- Update Rubocop and Test Kitchen dependencies to the latest versions
- Update Chefspec to 4.0
- Fix CentOS 5 support in the Kitchen config
- Fix rsyslog service notification in the file_input LWRP

v.1.14.0 (2015-01-30)
---------------------
- Don't attempt to use journald on Amazon Linux since Amazon Linux doesn't use systemd
- Fixed setting bad permissions on the working directory by using the rsyslog user/group variables.
- Fixed bad variable in the 49-relp.conf template that prevented Chef converges from completing.
- Removed the 'reload' action from the rsyslog service as newer rsyslog releases don't support reload.
- Updated Chefspecs to remove deprecation warnings and added additional tests.
- Removed node name from the comment block in the config files.
- Added a new file_input LWRP for defining configs.
- Added support for chef solo search cookbook.

v1.13.0 (2014-11-25)
--------------------
- Rsyslog's working directory is now an attribute and is set to the appropriate directory on RHEL based distros
- The working directory is now 0700 vs 0755 for additional security
- Add the ActionQueueMaxDiskSpace directive with a default of 1GB to prevent out of disk events during large buffering
- Updated RHEL / Fedora facilities to match those shipped by the distros
- Updated modules to match those used by journald (systemd) on Fedora 19+ and CentOS 7
- Added an attribute additional_directives to pass a hash of configs.  This is currently only being used to pass directives necessary for journald support on RHEL 7 / Fedora 19+
- Added basic SUSE support
- Fixed logic that prevented Ubuntu from properly dropping privileges in Ubuntu >= 11.04
- Removed references to rsyslog v3 in the config template
- Added a chefignore file
- Updated Gemfile with newer releases of Test Kitchen, Rubocop, and Berkshelf
- Added Fedora 20, Debian 6/7, CentOS 7, and Ubuntu 12.04/14.04 to the Test Kitchen config
- Removed an attribute that was in the Readme twice
- Updated Travis to Ruby 2.1.1 to better match Chef 12
- Updated the Berksfile to point to Supermarket
- Refactored the specs to be more dry

v1.12.2 (2014-02-28)
--------------------
Fixing bug fix in rsyslog.conf


v1.12.0 (2014-02-27)
--------------------
- [COOK-4021] Allow specifying default templates for local and remote
- [COOK-4126] rsyslog cookbook fails restarts due to not using upstart


v1.11.0 (2014-02-19)
--------------------
### Bug
- **[COOK-4256](https://tickets.opscode.com/browse/COOK-4256)** - Fix syntax errors in default.conf on rhel

### New Feature
- **[COOK-4022](https://tickets.opscode.com/browse/COOK-4022)** - Add use_local_ipv4 option to allow selecting internal interface on cloud systems
- **[COOK-4018](https://tickets.opscode.com/browse/COOK-4018)** - rsyslog TLS encryption support


v1.10.2
-------
No change. Version bump for toolchain.


v1.10.0
-------
### New Feature
- **[COOK-4021](https://tickets.opscode.com/browse/COOK-4021)** - Allow specifying default templates for local and remote

### Improvement
- **[COOK-3876](https://tickets.opscode.com/browse/COOK-3876)** - Cater for setting rate limits


v1.9.0
------
### New Feature
- **[COOK-3736](https://tickets.opscode.com/browse/COOK-3736)** - Support OmniOS

### Improvement
- **[COOK-3609](https://tickets.opscode.com/browse/COOK-3609)** - Add actionqueue to remote rsyslog configurations

### Bug
- **[COOK-3608](https://tickets.opscode.com/browse/COOK-3608)** - Add 50-default template knobs
- **[COOK-3600](https://tickets.opscode.com/browse/COOK-3600)** - SmartOS support


v1.8.0
------
### Improvement
- **[COOK-3573](https://tickets.opscode.com/browse/COOK-3573)** -  Add Test Kitchen, Specs, and Travis CI

### New Feature
- **[COOK-3435](https://tickets.opscode.com/browse/COOK-3435)** - Add support for relp

v1.7.0
------
### Improvement
- **[COOK-3253](https://tickets.opscode.com/browse/COOK-3253)** - Enable repeated message reduction
- **[COOK-3190](https://tickets.opscode.com/browse/COOK-3190)** - Allow specifying which logs to send to remote server
- **[COOK-2355](https://tickets.opscode.com/browse/COOK-2355)** - Support forwarding events to more than one server

v1.6.0
------
### New Feature
- [COOK-2831]: enable high precision timestamps

### Bug
- [COOK-2377]: calling node.save has adverse affects on nodes relying on a searched node's ohai attributes
- [COOK-2521]: rsyslog cookbook incorrectly sets directory ownership to rsyslog user
- [COOK-2540]: Syslogd needs to be disabled before starting rsyslogd on RHEL 5

### Improvement
- [COOK-2356]: rsyslog service supports status. Service should use it.
- [COOK-2357]: rsyslog cookbook copies in wrong defaults file on Ubuntu !9.10/10.04

v1.5.0
------
- [COOK-2141] - Add `$PreserveFQDN` configuration directive

v1.4.0
------
- [COOK-1877] - RHEL 6 support and refactoring

v1.3.0
------
- [COOK-1189] - template change does not restart rsyslog on Ubuntu

This actually went into 1.2.0 with action `:reload`, but that change has been reverted and the action is back to `:restart`.

v1.2.0
------
- [COOK-1678] - syslog user does not exist on debian 6.0 and ubuntu versions lower than 11.04
- [COOK-1650] - enable max message size configuration via attribute

v1.1.0
------
Changes from COOK-1167:

- More versatile server discovery - use the IP as an attribute, or use search (see README)
- Removed cron dependency.
- Removed log archival; logrotate is recommended.
- Add an attribute to select the per-host directory in the log dir
- Works with Chef Solo now.
- Set debian/ubuntu default user and group. Drop privileges to `syslog.adm`.


v1.0.0
------
- [COOK-836] - use an attribute to specify the role to search for instead of relying on the rsyslog['server'] attribute.
- Clean up attribute usage to use strings instead of symbols.
- Update this README.
- Better handling for chef-solo.
