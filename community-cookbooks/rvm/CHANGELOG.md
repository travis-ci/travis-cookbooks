## 0.10.1 (Unreleased)

### Breaking Changes

* Re-factored the libraries and shell wrappers to more of an [LWRP][] ([@fnichol][])

### Improvements

* Updated default ruby to 1.9.3-p547 ([@martinisoft][])
* Added a repository Code of Conduct (See CODE\_OF\_CONDUCT.md) ([@martinisoft][])

### Documentation

* Pull request [#246](https://github.com/fnichol/chef-rvm/pull/246): Updated README.md documenting use with librarian-chef ([@ncreuschling][])

### Bug Fixes

* Pull request [#285](https://github.com/fnichol/chef-rvm/pull/285): Use GPG for rvm verification. ([@lukeasrodgers][])
* Pull request [#284](https://github.com/fnichol/chef-rvm/pull/284): Use full class name for rvm_environment resource usage inside Chef::Provider::Package:RVMRubygems class. ([@nomadium][])
* Pull request [#300](https://github.com/fnichol/chef-rvm/pull/300): Ability to configure key server and home did for rvm gpg_key ([@lesniakania][])
* Pull request [#298](https://github.com/martinisoft/chef-rvm/pull/298): Add GPG check for user installs ([@cmluciano][])
* Pull request [#325](https://github.com/martinisoft/chef-rvm/pull/325): Fix ruby block to align with new style ([@cmluciano][])

## 0.9.2 (March 31, 2014)

### Bug fixes

* Pull request [#137](https://github.com/fnichol/chef-rvm/pull/137): Fix patch attribute support in rvm\_ruby. ([@mariussturm][])
* Pull request [#140](https://github.com/fnichol/chef-rvm/pull/140): Update MRI package requirements for scientific-6 platforms. ([@aaronjensen][])
* Pull request [#134](https://github.com/fnichol/chef-rvm/pull/134): Fix vagrant\_ruby default location on modern vagrant baseboxes. ([@mveytsman][])
* Pull request [#129](https://github.com/fnichol/chef-rvm/pull/129): Fix broken example in README. ([@zacharydanger][])
* Pull request [#188](https://github.com/fnichol/chef-rvm/pull/188): Added missing dependencies. ([@fmfdias][])
* Pull request [#151](https://github.com/fnichol/chef-rvm/pull/151): Add Berkshelf installation instructions. ([@justincampbell][])
* Pull request [#128](https://github.com/fnichol/chef-rvm/pull/128): Allow for universal rvmrc settings to be used in the user\_install. ([@firebelly][])
* Pull request [#204](https://github.com/fnichol/chef-rvm/pull/204): Minor spelling mistake ([@dosire][])
* Pull request [#183](https://github.com/fnichol/chef-rvm/pull/183): Only log install when it actually happens ([@zsol][])

### New features

* Pull request [#100](https://github.com/fnichol/chef-rvm/pull/100): Add rubygems\_version attribute to rvm\_ruby resource. ([@cgriego][])
* Pull request [#125](https://github.com/fnichol/chef-rvm/pull/125): Omnibus support (via chef\_gem). ([@gondoi][], [@cgriego][], [@jblatt-verticloud][], [@jschneiderhan][])
* Set name attribute in metadata.rb, which may help certain LWRP auto-naming issues when directory name does not match 'rvm' (FC045). ([@fnichol][])

### Improvements

* Refactor foodcritic setup. ([@fnichol][])
* Now suggests the [homebrew](http://community.opscode.com/cookbooks/homebrew) cookbook ([@martinisoft][])

## 0.9.0 (May 15, 2012)

### RVM API tracking updates

* Drop rake 0.9.2 from default global gems to match upstream default. ([@fnichol][])
* Use RVM stable (stable/head) by default. ([@fnichol][])
* Pull request [#84](https://github.com/fnichol/chef-rvm/pull/84): Add stable support to installer. ([@xdissent][])
* Pull request [#102](https://github.com/fnichol/chef-rvm/pull/102): Switch URLs to rvm.io and add "rvm get stable". ([@mpapis][])

### Bug fixes

* Pull request [#64](https://github.com/fnichol/chef-rvm/pull/64): Fix check for rvm in user install. ([@dokipen][])
* Issue [#61](https://github.com/fnichol/chef-rvm/issues/61): Include Chef::RVM::StringHelpers to provide select_ruby function. ([@jheth][])
* Pull request [#94](https://github.com/fnichol/chef-rvm/pull/94): Prevent rvm from reinstalling each chef run. ([@xdissent][])
* Pull request [#66](https://github.com/fnichol/chef-rvm/pull/66): Fixing NoMethodError when using system wide rvm and the gem_package resource. ([@kristopher][])
* Pull request [#95](https://github.com/fnichol/chef-rvm/pull/95): Fix missing `patch` resource attributes. ([@xdissent][])
* Pull request [#96](https://github.com/fnichol/chef-rvm/pull/96): Fix wrapper paths, now works for both system and user installs. ([@xdissent][])
* LWRPs now notify when updated (FC017). ([@fnichol][])
* Node attribute access style (FC019). ([@fnichol][])
* FC023: Prefer conditional attributes. ([@fnichol][])

### New features

* Update default Ruby to ruby-1.9.3-p194 (it's time). ([@fnichol][])
* Pull request [#86](https://github.com/fnichol/chef-rvm/pull/76): Add patch attribute to rvm_ruby. ([@smdern][])
* Pull request [#76](https://github.com/fnichol/chef-rvm/pull/76): Add wrapper for chef-client. ([@bryanstearns][])

### Improvements

* Add TravisCI support for Foodcritic. ([@fnichol][])
* Large formatting updates to README. ([@fnichol][])
* Add gh-pages branch for sectioned README at https://fnichol.github.com/chef-rvm. ([@fnichol][])
* Issue [#98](https://github.com/fnichol/chef-rvm/issues/98): Support installs of x.y.z versions & more permissive upgrade options. ([@fnichol][])
* Now rvm\_global\_gem respects version attr in global.gems file. ([@fnichol][])
* Pull request [#88](https://github.com/fnichol/chef-rvm/pull/88): Mac OS X Server support. ([@rhenning][])
* Pull request [#90](https://github.com/fnichol/chef-rvm/pull/90): Scientific Linux support. ([@TrevorBramble][])


## 0.8.6 (November 28, 2011)

### RVM API tracking updates

* Issue [#56](https://github.com/fnichol/chef-rvm/issues/56): Ensure that RVM version strings can be converted to RubyGems format. ([@fnichol][])
* Issue [#53](https://github.com/fnichol/chef-rvm/issues/53): Update rvm/installer\_url default to latest URL. ([@fnichol][])

### Bug fixes

* Issue [#54](https://github.com/fnichol/chef-rvm/issues/54), Pull request [#55](https://github.com/fnichol/chef-rvm/pull/55): Fix if statement typo in `RVM::RubyGems::Package`. ([@bradphelan][])
* Pull request [#57](https://github.com/fnichol/chef-rvm/pull/57): Fix typo in `RVM::RubyGems::Package`. ([@bradphelan][])

### Improvements

* Add note to README warning that chef 0.8.x will not work. ([@fnichol][])
* Issue [#48](https://github.com/fnichol/chef-rvm/issues/48): Add example of local gem source installation in README. ([@fnichol][])


## 0.8.4 (October 16, 2011)

### RVM API tracking updates

* Issue [#43](https://github.com/fnichol/chef-rvm/issues/43), Pull request [#46](https://github.com/fnichol/chef-rvm/pull/46): Make explicit use of `exec` for RVM versions older than 1.8.6 and `do` for newer versions. ([@ryansch][], [@fnichol][])

### Bug fixes

* Pull request [#39](https://github.com/fnichol/chef-rvm/pull/39): Fix rvm_ruby provider on Ubuntu/Debian when installing JRuby. ([@exempla][])
* Issues [#38](https://github.com/fnichol/chef-rvm/issues/38), [#42](https://github.com/fnichol/chef-rvm/issues/42): Update user_installs attribute to be an array of hashes in README. ([@fnichol][])

### New features

* Pull request [#47](https://github.com/fnichol/chef-rvm/pull/47): Handle installing a gem from a local file. ([@ryansch][])

### Improvements

* Pull request [#44](https://github.com/fnichol/chef-rvm/pull/44): Add Amazon's Linux AMI support. ([@adrianpike][])


## 0.8.2 (August 24, 2011)

### Bug fixes

* Ensure Ruby/gemset is installed in rvm_shell provider. ([@fnichol][])
* Issue [#35](https://github.com/fnichol/chef-rvm/issues/35): Detect if user has RVM installed in rvm_shell provider. ([@fnichol][])

### Improvements

* Array-ize node['rvm']['user_installs']. ([@fnichol][])


## 0.8.0 (August 22, 2011)

### Bug fixes

* Pull request [#22](https://github.com/fnichol/chef-rvm/pull/22): Expand list of sane rubies to include `"ree"` and `"kiji"`. ([@juzzin][])
* Pull request [#26](https://github.com/fnichol/chef-rvm/pull/26): RVM is installed in compilation phase when gem_package recipe is included. ([@temujin9][], [@fnichol][])
* Update rvm/vagrant/system_chef_solo default attribute value to match newest Vagrant lucid32 basebox. ([@fnichol][])
* Pull request [#27](https://github.com/fnichol/chef-rvm/pull/27): Explicitly handle the unmanaged 'system' ruby. ([@temujin9][]).
* Pull request [#28](https://github.com/fnichol/chef-rvm/pull/28): Fix bug when no RVM rubies had yet been installed. ([@relistan][]).
* Pull request [#30](https://github.com/fnichol/chef-rvm/pull/30): Implement 'group_users' support. ([@phlipper][]).
* Update ruby compilation dependencies for debian/ubuntu. ([@fnichol][])

### New features

* Issue [#4](https://github.com/fnichol/chef-rvm/issues/4): Per-user RVM installs with support in all LWRPs. ([@fnichol][])
* Refactor system and user installs into: system_install, system, user_install, user ([reference](https://github.com/fnichol/chef-rvm/commit/69027cafbe8e25251a797f1dcf11e5bc4c96275b)). ([@fnichol][])
* Support Mac OS X platform for system-wide and per-user installs. ([@fnichol][])
* Issue [#23](https://github.com/fnichol/chef-rvm/issues/24): Let gem_package resource target multiple RVM rubies. ([@fnichol][])
* Pull request [#26](https://github.com/fnichol/chef-rvm/pull/26): Add new attribute `group_id`. ([@temujin9][])
* General refactoring and re-modularizing. ([@fnichol][])

### Improvements

* Pull request [#26](https://github.com/fnichol/chef-rvm/pull/26): RVM unix group is created in compilation phase if GID is provided. ([@temujin9][])
* Revamp CHANGELOG in the style of [guard](https://github.com/guard/guard). ([@fnichol][])
* Pull request [#27](https://github.com/fnichol/chef-rvm/pull/27): Improve gem_package logging message to include full list of selected rubies. ([@temujin9][])
* RVM gem installed using opscode cookbook conventions (via gem_package). ([@fnichol][])
* Add RVM::Shell::ChefWrapper based on chef's popen4 impl. ([@fnichol][])
* Create RVM::ChefUserEnvironment which can be injected with a user. ([@fnichol][])
* Normalize 'missing gem' logging notices. ([@fnichol][])
* Add Chef::RVM::StringCache to get and cache canonical RVM strings. ([@fnichol][])
* Modularize `libraries/helpers.rb` in modules. ([@fnichol][])
* Issue [#25](https://github.com/fnichol/chef-rvm/issues/25): Add installation options/instructions to README. ([@fnichol][])


## 0.7.1 (May 15, 2011)

### Bug fixes

* Issue [#20](https://github.com/fnichol/chef-rvm/issues/20): Update metadata.rb to not include README.md (too long). ([@fnichol][])

### New features

* Add Rakefile for opscode platform deploy builds. ([@fnichol][])

### Improvements

* Update metadata.rb properties. ([@fnichol][])


## 0.7.0 (May 14, 2011)

### Bug fixes

* Issue [#20](https://github.com/fnichol/chef-rvm/issues/20): Update rvm/install_rubies attr to "true"/"false". ([@fnichol][])
* Issue [#14](https://github.com/fnichol/chef-rvm/issues/14): Allow no default RVM ruby (i.e. use system ruby). ([@fnichol][])
* Issue [#12](https://github.com/fnichol/chef-rvm/issues/12): Update RVM install to use SSL URL. ([@fnichol][])
* Now /etc/rvmrc has export for rvm/rvmrc key/value pairs. ([@fnichol][])

### New features

* Issue [#13](https://github.com/fnichol/chef-rvm/issues/13): Speed up install by disabling RDOC generation. ([@fnichol][])
* New experimental recipe gem_package which patches gem_package resource. ([@fnichol][])
* Add rvm_global_gem resource. ([@fnichol][])

### Improvements

* Issue [#3](https://github.com/fnichol/chef-rvm/issues/3): Revamp and update README.md. ([@fnichol][])
* Issue [#3](https://github.com/fnichol/chef-rvm/issues/5): Add CHANGELOG.md. ([@fnichol][])
* Issue [#19](https://github.com/fnichol/chef-rvm/issues/19): Attr rvm/upgrade accepts "none", false and nil as same value. ([@fnichol][])
* Update rvm/skip_docs_on_install attr to rvm/rvm_gem_options. ([@fnichol][])
* Refactor of rvm_gem provider to leverage Chef::Provider::Package::Rubygems. ([@fnichol][])


## Previous releases

The changelog began with version 0.6.0 so any changes prior to that can be
seen by checking the tagged releases and reading git commit messages.

[LWRP]: https://docs.getchef.com/lwrp.html
[@aaronjensen]: https://github.com/aaronjensen
[@adrianpike]: https://github.com/adrianpike
[@bradphelan]: https://github.com/bradphelan
[@bryanstearns]: https://github.com/bryanstearns
[@cgriego]: https://github.com/cgriego
[@dokipen]: https://github.com/dokipen
[@exempla]: https://github.com/exempla
[@fnichol]: https://github.com/fnichol
[@gondoi]: https://github.com/gondoi
[@jblatt-verticloud]: https://github.com/jblatt-verticloud
[@jheth]: https://github.com/jheth
[@jschneiderhan]: https://github.com/jschneiderhan
[@juzzin]: https://github.com/juzzin
[@kristopher]: https://github.com/kristopher
[@mariussturm]: https://github.com/mariussturm
[@mpapis]: https://github.com/mpapis
[@mveytsman]: https://github.com/mveytsman
[@phlipper]: https://github.com/phlipper
[@relistan]: https://github.com/relistan
[@rhenning]: https://github.com/rhenning
[@ryansch]: https://github.com/ryansch
[@smdern]: https://github.com/smdern
[@temujin9]: https://github.com/temujin9
[@TrevorBramble]: https://github.com/TrevorBramble
[@xdissent]: https://github.com/xdissent
[@zacharydanger]: https://github.com/zacharydanger
[@fmfdias]: https://github.com/fmfdias
[@justincampbell]: https://github.com/justincampbell
[@firebelly]: https://github.com/firebelly
[@martinisoft]: https://github.com/martinisoft
[@dosire]: https://github.com/dosire
[@zsol]: https://github.com/zsol
[@ncreuschling]: https://github.com/ncreuschling
[@lukeasrodgers]: https://github.com/lukeasrodgers
[@nomadium]: https://github.com/nomadium
[@lesniakania]: https://github.com/lesniakania
[@cmluciano]: https://github.com/cmluciano
