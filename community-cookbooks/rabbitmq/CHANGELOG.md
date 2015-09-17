# rabbitmq Cookbook CHANGELOG

This file is used to list changes made in each version of the rabbitmq cookbook.

## v4.2.0 (2015-08-28)
- Updated the CHANGELOG.md formatting
- PR #295
- PR #290
- PR #294
- PR #293
- PR #292
- PR #296
- PR #297

## v4.1.2 (2015-06-16)
- Stupid Rubocop

## v4.1.1 (2015-07-17)
- Allow for flexiable SSL cipher formats #280
- Use gsub instead of gsub! #284
- Support rabbitmq_user with multiple vhosts. #279
- Fix exception when first node is launched. Fixes issue #285 #286
- Allow the service to be manually managed #281
- Fix user_has_tag? issue when name and tag are the same #140

## v4.0.1 (2015-06-16)
- Fix single quote and nil issues with cluster recipe #274
- Fixed 'rabbitmqctl eval' command for old rabbitmq versions #272
- Support additional env args #269
- Add patterns to catch where the node name is surrounded by single-quotes #267
- Remove the extra curly braces for format_ssl_ciphers #260

## v4.0.0 (2015-04-23)
- added #238 for clustering depreciating the [rabbitmq-cluster cookbook](https://supermarket.chef.io/cookbooks/rabbitmq-cluster)
- added #245 for expected Debian family usage

## v3.13.0 (2015-04-23)
- Added ssl_ciphers #255
- Fix plugin_enabled not having path appended #253
- Add more support for erlang args #247
- Open file limit not set correctly #127
- Additional rabbit configs #217
- Updated the erlang cookbook dependancy

## v3.12.0 (2015-04-07)
- Removed yum-epel case statement #236
- don't put change password in log #237
- Added pin_distro_version for other platforms #234
- specifying ssl #152
- additional debs and rpms #220
- umask #219
- typo fixed #243

## v3.11.0 (2015-02-25)
- Fix travis build. #228
- Update Contributing file with new links and help. #229
- Change module back to Opscode. #231
- Update for 3.4.4 #223
- Exclude CentOS 6/7 from distro version suite (no or broken upstream)

## v3.10.0 (2015-02-05)
Song of this Release: [First Person Shooter](http://www.pandora.com/celldweller/soundtrack-for-voices-in-my-head-vol-02/1st-person-shooter) by Celldweller

- Add more chefspec tests #193
- initial enforcement of Gemfile.lock #213
- add support for loopback users #212
- CentOS 7 support #214
- changed regex behavior for guard command on set user permission resource #215

## v3.9.0 (2015-01-28)
Song of this Release: [Cascade](http://www.pandora.com/hyper/we-control/cascade) by Hyper

- Moved the service enable and start to the bottom of the default recipe so you can change variables around. Issue #201
- syntax typos #208
- LWRP for managing RabbitMQ parameters #207
- Distro version pinning #211

## v3.8.0 (2015-01-07)
Song of this Release: Sunlight (2011) by by Modestep

- Update to `3.4.3` release of rabbitmq
- Updated from 12.04 to 14.04 for Ubuntu Specs

## v3.7.0 (2014-12-18)
- #185 Updated cloud kitchen.yml
- #186 Updated chefspec for multiple oses
- #180 Instead of defaulting to :upgrade we default to :install with the a pinned version number
- #187 Updating Readme
- #184 Supports setting rabbitmq config file to a different path

## v3.6.0 (2014-12-9)
- #161 Community plugins
- #158 Adds policy apply_to option
- #151 make config file template source cookbook configurable
- #121 COOK-4694 Remove service restart for vhost mgmnt

## v3.5.1 (2014-12-5)
- #176 Chef-client 12 released and the `PATH` attribute was removed.

## v3.5.0 (2014-12-2)
Song of this Release: 0 to 100/The Catchup by Drake

- Updated for the new release of RabbitMQ release 3.4.2
- Removed the Centos 5.10 from integration testing
- Updated the Gemfile for testing
- #87 expose the heartbeat configuration parameter
- #168 Initial Chefspec
- #166 Updated to 3.4.2 release
- d1bfae8 Rubocop'd all the things
- ccf42a3 Started to get Travis to be our gatekeeper
- #172 Updates ['rabbitmq']['config'] to use ['rabbitmq']['config_root'] attribute
- #123 Add raw configuration for rabbitmq.erb

## v3.4.0 (2014-11-23)
- Updated the RuboCop camel case
- Make rabbitmq service restart immediately
- Add sensitive flag for resources that expose passwords in log
- Issue: #153
- move serverspec v1 tests to use busser-rspec
- Adding switch to make TCP listeners optional
- Update user.rb
- Update default.rb
- Merge branch 'pr-128'
- add serverspec tests for plugin lwrp
- Plugin provider. fixes #141
- Add test that fails if plugin notifications aren't working properly.

## v3.3.0 (2014-08-28)
- Bump default rabbitmq-server version to 3.3.5
- [COOK-4641] - remove setsid calls in service resource
- Testing updates
- Minor documentation fix re: rabbitmq_policy usage

## v3.2.2 (2014-05-07)
- [COOK-2676] - Fixing startup issue when cluster mode is enabled


## v3.2.0 (2014-04-23)
- [COOK-4517] - Add cluster partition handling attribute to the cookbook

## v3.1.0 (2014-03-27)
- [COOK-4459] - added missing dependency package logrotate
- [COOK-4279] - Addition of ssl_opts in rabbitmq.config when web_console_ssl is enabled

## v3.0.4 (2014-03-19)
- [COOK-4431] - RPM / DEB package installs now use the rabbit version you specify
- [COOK-4438] - rabbitmq_policy resource breaks if you use rabbitmq version >= 3.2


## v3.0.2 (2014-02-27)
- [COOK-4384] Add ChefSpec Custom Matchers for LWRPs


## v3.0.0 (2014-02-27)
[COOK-4369] - use_inline_resources


## v2.4.2 (2014-02-27)
[COOK-4280] Upstart script properly waits until the server is started


## v2.4.0 (2014-02-14)
- [COOK-4050] - Do not force failure in rabbitmq_user
- [COOK-4088] - Update rabbitmq.config for port ranges
- Updating test harness. Fixing style cops


## v2.3.2
### Bug
- **[COOK-3678](https://tickets.chef.io/browse/COOK-3678)** - Fix an issue where a RabbitMQ policy resource with vhost arguments emits unexpected restart notification
- **[COOK-3606](https://tickets.chef.io/browse/COOK-3606)** - Fix erlang cookie comparison
- **[COOK-3512](https://tickets.chef.io/browse/COOK-3512)** - Define rabbitmq service on SUSE

### New Feature
- **[COOK-3538](https://tickets.chef.io/browse/COOK-3538)** - Configure web management console to use SSL


## v2.3.0

### Improvement
- **[COOK-3369](https://tickets.chef.io/browse/COOK-3369)** - Add SUSE support
- **[COOK-3320](https://tickets.chef.io/browse/COOK-3320)** - Configure bind and cluster over a specified addr
- **[COOK-3138](https://tickets.chef.io/browse/COOK-3138)** - Do not log RabbitMQ password
- **[COOK-2803](https://tickets.chef.io/browse/COOK-2803)** - Bind erlang networking to localhost (attribute-driven)

## v2.2.0
### Improvement
- Greatly expanded Test Kitchen coverage and platform support
- added support for disabling policies and virtualhosts through attributes
- added support for using with the erlang::esl recipe
- [COOK-2705]: Add ability to change tcp_listen_options in config
- [COOK-2397]: Added upstart support to rabbitmq cookbook
- [COOK-2830]: Use a notify for server restart, instead of defining a new service
- [COOK-3384]: Added ability to change user password
- [COOK-3489]: Add attribute to set open file limit

### Bug
- [COOK-3011]: Incorrect apt source test causes Chef run to fail on Ubuntu
- [COOK-3438]: RabbitMQ fixes for Fedora 19

## v2.1.2
### Improvement
- [COOK-3099]: policy resource should support optional vhost argument

### Bug

- [COOK-3078]: rabbitmq password is not quoted or escaped on add_user
- [COOK-3079]: rabbitmq permissions check doesn't match, resulting in non-idempotency

## v2.1.0
### Bug
- [COOK-2828]: Rabbitmq Clustering doesn't work properly
- [COOK-2975]: rabbitmq has foodcritic failures

### New Feature
- [COOK-2575]: LWRP for setting policies

## v2.0.0
- Major v2.0 changes are documented in the README.
- [COOK-2391] - Added support for verify verify_peer and fail_if_no_peer_cert true
- [COOK-2153] - Fix of user LWRP
- [COOK-2180] - Plugin management via node attributes
- [COOK-2201] - Use the proper syntax when using rabbitmq 3.0 instead of 2.x
- [COOK-2210] - User management via node attributes
- [COOK-2211] - Virtualhost management via node attributes
- [COOK-2235] - RabbitMQ bin path isn't necessarily part of PATH for the plugin provider
- [COOK-2392] - correctly configure a rabbitmq cluster
- [COOK-2366] - Default recipe doesn't create mnesia dir
- [COOK-2416] - Add support for clearing tags.

## v1.8.0
- [COOK-2151] - Add config options for `disk_free_limit` and `vm_memory_high_watermark` via attributes

## v1.7.0
- [COOK-1850] - oracle linux support
- [COOK-1873] - add `set_user_tag` action to `rabbitmq_user` LWRP
- [COOK-1878] - :immediately action causes clustering to fail
- [COOK-1888] - smartos support

## v1.6.4
- [COOK-1684] - Unify behavior of debian and rhel clones in the rabbitmq cookbook
- [COOK-1724] - enable using the distro release of rabbitmq instead of the RabbitMQ.org version

## v1.6.2
- [COOK-1552] - removed rogue single quote from rabbitmq ssl configuration

## v1.6.0
- [COOK-1496] - explicitly include the apt recipe
- [COOK-1501] - Allow user to enable yum-based installation of rabbitmq via an attribute
- [COOK-1503] - Recipe to enable rabbitmq web management console

## v1.5.0
This version requires apt cookbook v1.4.4 (reflected in metadata).

- [COOK-1216] - add amazon linux to RHELish platforms
- [COOK-1217] - specify version, for RHELish platforms
- [COOK-1219] - immediately restart service on config update
- [COOK-1317] - fix installation of old version from ubuntu APT repo
- [COOK-1331] - LWRP for enabling/disabling rabbitmq plugins
- [COOK-1386] - increment rabbitmq version to 2.8.4
- [COOK-1432] - resolve foodcritic warnings
- [COOK-1438] - add fedora to RHELish platforms

## v1.4.1
- [COOK-1386] - Bumped version to 2.8.4
- rabbitmq::default now includes erlang::default

## v1.4.0
- [COOK-911] - Auto clustering support

## v1.3.2
- [COOK-585] - manage rabbitmq-server service
