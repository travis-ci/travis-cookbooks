Java Cookbook CHANGELOG
=======================
This file is used to list changes made in each version of the Java cookbook.

v1.49.0 - 04/21/2017
----
- potential 'curl' resource cloning #415
- Oracle 8u131
- Add chefspec matchers for java_certificate resource
- Remove unnecessary apt update

v1.48.0 - 03/31/2017
----
- Update Oracle Java links from 101 to 121
- Remove convergence report
- Remove Fedora 24 testing
- Fix test cookbook license
- Update platforms in the specs
- Remove testing on EOL platforms

v1.47.0 - 01/30/2017
-----
- Fix typo in method name (#397)
- Remove useless ruby_block[set-env-java-home]
- Update README: using java::notify
- Add forgotten "do" to README

v1.46.0 - 01/09/2017
-----
- fix jce installation on windows #386

v1.45.0 - 12/27/2016
-----
- Update to resolve latest rubocop rules

v1.44.0 - 12/27/2016
-----
- Unpublished due to newer rubocop rules in travis
- Added zlinux defaults

v1.43.0 - 12/6/2016
-----
- Switch recursive chown from executing on the jdk parent directory to executing on the jdk directory itself.
- Added proxy support to curl
- add java_certificate LWRP from java-libraries cookbook - java-libraries now depricated.
- (Windows) support removal of obsolete JREs via optional attribute
- (Windows) Can download from s3 only using an IAM profile
- (Windows) aws session token for windows java download

v1.42.0 - 8/8/2016
-----
- Use openjdk ppa for all ubuntu versions to allow for older/newer jdks to be installed. Fixes #368
- update oracle java 8u101 - Use sha256 hash (seems to help with downloading each converge)
- Mac default converge fails since notify is not included by homebrew
- Remove chef 14(!) depreciation warning in tests
- Resolve chef-12 related warning

v1.41.0 - 7/15/2016
-----
- Feature: Add new resource for cookbooks to subscribe to, see README
- Use a remote_file resource for JCE download instead of curl in an execute block.
- Since v1.40.4 Travis deploys cookbook to supermarket - expect more frequent,
  smaller releases.

v1.40.4 - 7/12/2016
-----
- Automated deploy, no cookbook changes.

v1.40.3 - 7/12/2016
-----
- Attempt to have travis publish this.
- Mac depends on homebrew.
- Fixed typo in platform family spelling for OS X
- fix openjdk version logic for freebsd
- Enable Ark provider to handle URI with get parameters

v1.40.1 - 7/8/2016
-----
- Fixed: JAVA_HOME not set on systems with restrictive umask #359

v1.40 - 6/29/2016
-----
- Travis build green
- Add Windows JCE support
- Changes to prevent re-execution of resource creating file '/etc/profile.d/jdk.sh'
- Fix JDK checksum
- Update ibm_jdk.installer.properties.erb for IBM JDK 1.8
- Install OpenJDK from distribution if Ubuntu version >= 15.10
- Fixes #342 - Tar is included in macosx and homebrews package is gnutar which
  causes this to fail
- Add 12.04 to jdk8 test suite
- Add source and issues urls to supermarket
- Distinguishing the Java version for installing on the Mac OS X
- Doc and cruft cleanup

v1.39 - 1/14/2016
-----
- Travis debugging only, no code changes.

v1.38 - 1/13/2016
-----
- (Win) Fix for Java install failing on Windows (introduced in #315)
- Travis fixes/badge

v1.37 - 11/9/2015
------
- (Win) Attirbute for specifying the install directory for the public jre #315

v1.36 - 9/3/2015
------
- Oracle JDK 1.8.0_65
- Add Ubuntu ppa (allows OpenJDK 8)
- Added ChefSpec matchers #284
- Fix compile error using Chef::Application.fatal #279
- #222 Provide possibility to set ark download timeout
- Openjdk6 does not exist in deb 8.2
- Change to create java home dir even if top level doesn't exist(Eg mkdir_p instead of mkdir)
- Fix berks url and remove apt
- Documentation and dependency updates

v1.35 - 8/4/2015
-------
- Use bento boxes and remove EOL distros from testing suite.
- Update to latest JDKs. Note Oracle JDK7 is now EOL.
- Alternatives improvements
- Fixes #155 to allow install of OpenJDK 1.8
- Fixes #257 Changed switches for the jdk 8 exe installer on windows
- Make sure tar package installed for java_ark
- Add support for Mac OS X "mac_os_x" via homebrew.
- Update metadata.rb to contain source and issue information for supermarket and chef-repo convenience

### Known Issues
- Kitchen CI test with 12.04 fails due to hostname unable to be set.

v1.31 - 2/3/2015
-------
- Update to latest JDKs for 7 and 8. JDK7 will be EOL April 2015
- Fix up Travis support.
- Add ability to install JCE policy files for oracle JDK #228
- Change connect timeout to 30 seconds

v1.29.0 - 11/14/2014
-------
### Bug
- **[#216](https://github.com/agileorbit-cookbooks/java/pull/216)** - Ensure dirs, links, and jinfo files are owned correctly
- **[#217](https://github.com/agileorbit-cookbooks/java/pull/217)** - Update to Oracle JDK 8u25
- **[#214](https://github.com/agileorbit-cookbooks/java/pull/214)** - Update to Oracle JDK 7u71-b14

### Improvement
- Adding a connect_timeout option for downloading java.

### Misc
- Switched to chef-zero provisioner in test suites.
- Adding ISSUES.md for guidance on creating new issues for the Java cookbook.
- Fix IBM unit tests.

v1.28.0 - 9/6/2014
-------
### Improvement
- Allow setting of group to extracted java files.

### Bug
- Add -no-same-owner parameter to tar extract to avoid issues when the chef cache dir is on an NFS mounted drive.
- In the ark provider, it doesn't compare the MD5 sum with the right value which causes Java cookbook always download tarball from oracle server

v1.27.0 - 8/22/2014
-------
- Update Oracle JDK8 to version 8u20

v1.26.0 - 8/16/2014
-------
- **[#201](https://github.com/agileorbit-cookbooks/java/pull/201)** - Allow pinning of package versions for openjdk
- **[#198](https://github.com/agileorbit-cookbooks/java/pull/198)** - Update Oracle JDK7 to version 7u67
- **[#189](https://github.com/agileorbit-cookbooks/java/pull/184)** - Support specific version and name for Oracle RPM

v1.25.0 - 8/1/2014
-------
### Improvement
- **[#189](https://github.com/agileorbit-cookbooks/java/pull/189)** - Resource ark -> attribute bin_cmds default value
- **[#168](https://github.com/agileorbit-cookbooks/java/pull/168)** - Add option to put JAVA_HOME in /etc/environment
- **[#172](https://github.com/agileorbit-cookbooks/java/pull/172)** - Allow ark to pull from http and files ending in .gz.

### Documentation
- Recommendations for inclusion in community cookbooks
- Production Deployment with Oracle Java
- Update testing instructions for chefdk
- Various Readme formatting.

### Misc
- Use Supermarket endpoint in berksfile
- rspec cleanup
- Adding ubuntu-14.04 to test suite

v1.24.0 - 7/25/2014
-------
New Cookbook maintainer! **[Agile Orbit](http://agileorbit.com)**

### Improvement
- **[#192](https://github.com/agileorbit-cookbooks/java/pull/192)** - Bump JDK7 URLs to 7u65
- **[#191](https://github.com/agileorbit-cookbooks/java/pull/192)** - Upgrade Oracle's Java 8 to u11
- **[#188](https://github.com/agileorbit-cookbooks/java/pull/188)** - Allow for alternatives priority to be set from attribute.
- **[#176](https://github.com/agileorbit-cookbooks/java/pull/176)** - Change ownership of extracted files
- **[#169](https://github.com/agileorbit-cookbooks/java/pull/169)** - Add retries and retry_delay parameters to java_ark LWRP
- **[#167](https://github.com/agileorbit-cookbooks/java/pull/167)** - default: don't fail when using java 8 on windows
- **[#165](https://github.com/agileorbit-cookbooks/java/pull/165)** - Support for Server JRE
- **[#158](https://github.com/agileorbit-cookbooks/java/pull/158)** - Updated README for accepting oracle terms
- **[#157](https://github.com/agileorbit-cookbooks/java/pull/157)** -Remove VirtualBox specific box_urls
- List AgileOrbit as the maintainer (AgileOrbit took over from Socrata in July 2014)

v1.23.0 - 7/25/2014
-------
- Tagged but never published to community cookbooks. All changes rolled into 1.24.0

v1.22.0
-------
### Improvement
- **[#148](https://github.com/socrata-cookbooks/java/pull/148)** - Add support for Oracle JDK 1.8.0
- **[#150](https://github.com/socrata-cookbooks/java/pull/150)** - Make use of Chef's cache directory instead of /tmp
- **[#151](https://github.com/socrata-cookbooks/java/pull/151)** - Update Test Kitchen suites
- **[#154](https://github.com/socrata-cookbooks/java/pull/154)** - Add safety check for JDK 8 on non-Oracle

v1.21.2
-------
### Bug
- **[#146](https://github.com/socrata-cookbooks/java/pull/146)** - Update Oracle accept-license-terms cookie format

v1.21.0
-------
### Improvement
- **[#143](https://github.com/socrata-cookbooks/java/pull/143)** - Symlink /usr/lib/jvm/default-java for both OpenJDK and Oracle
- **[#144](https://github.com/socrata-cookbooks/java/pull/144)** - Remove /var/lib/alternatives/#{cmd} before calling alternatives (Hopefully fixes sporadic issues when setting alternatives)
- **[Make default_java_symlink conditional on set_default attribute](https://github.com/socrata-cookbooks/java/commit/e300e235a463382a5022e1dddaac674930b4d138)**

v1.20.0
-------
### Improvement
- **[#137](https://github.com/socrata-cookbooks/java/pull/137)** - Create /usr/lib/jvm/default-java on Debian
- **[#138](https://github.com/socrata-cookbooks/java/pull/138)** - allow wrapping cookbook without providing templates
- **[#140](https://github.com/socrata-cookbooks/java/pull/140)** - Adds set_default attribute to toggle setting JDK as default

### Bug
- **[#141](https://github.com/socrata-cookbooks/java/pull/141)** - set java_home correctly for oracle_rpm

v1.19.2
-------
### Improvement
- **[#129](https://github.com/socrata-cookbooks/java/pull/129)** - Upgrade to ChefSpec 3
- Rewrite unit tests for better coverage and to work with ChefSpec 3 (various commits)
- List Socrata as the maintainer (Socrata took over from Opscode in December 2013)

### Bug
- **[#133](https://github.com/socrata-cookbooks/java/pull/133)** - Allow jdk_version to be a string or number
- **[#131](https://github.com/socrata-cookbooks/java/pull/131)** - Fix JDK install on Windows
- **[Fix openjdk_packages on Arch Linux](https://github.com/socrata-cookbooks/java/commit/677bee7b9bf08988596d40ac65e75984a86bda99)**

v1.19.0
-------
Refactor the cookbook to better support wrapper cookbooks and other cookbook authoring patterns.
### Improvement
- **[#123](https://github.com/socrata-cookbooks/java/pull/123)** - Update documentation & add warning for issue 122
- **[#124](https://github.com/socrata-cookbooks/java/pull/124)** - Refactor default recipe to better enable wrapper cookbooks
- **[#125](https://github.com/socrata-cookbooks/java/pull/125)** - Removes the attribute to purge deprecated packages
- **[#127](https://github.com/socrata-cookbooks/java/pull/127)** - Add safety check if attributes are unset
- **[Adds tests for directly using openjdk and oracle recipes](https://github.com/socrata-cookbooks/java/commit/794df596959d65a1a6d5f6c52688bffd8de6bff4)**
- **[Adds recipes to README](https://github.com/socrata-cookbooks/java/commit/76d52114bb9df084174d43fed143123b1cdbae16)**
- **[The Opscode CCLA is no longer required](https://github.com/socrata-cookbooks/java/commit/ce4ac25caa8383f185c25c4e32cafef8c0453376)**
- **[Adds tests for openjdk-7 and oracle-7](https://github.com/socrata-cookbooks/java/commit/9c38af241f68b3198cde4ad6fe2b4cb752062009)**


### Bug
- **[#119](https://github.com/socrata-cookbooks/java/pull/119)** - Use java_home instead of java_location for update-alternatives
- **[Fix java_home for rhel and fedora](https://github.com/socrata-cookbooks/java/commit/71dadbd1bfe2eab50ff21cdab4ded97877911cc4)**

v1.18.0
-------
### Improvement
- **[#118](https://github.com/socrata-cookbooks/java/pull/118)** - Upgrade to 7u51
- **[#117](https://github.com/socrata-cookbooks/java/pull/117)** - Suggest windows and aws

v1.17.6
-------
### Bug
- Revert **[COOK-4165](https://tickets.opscode.com/browse/COOK-4165)** - The headers option was only added to remote_file in Chef 11.6.0, meaning this change breaks older clients.

v1.17.4
-------
### Bug
- **[#111](https://github.com/socrata-cookbooks/java/pull/111)** - Fix alternatives for centos

### Improvement
- **[COOK-4165](https://tickets.opscode.com/browse/COOK-4165)** - Replace curl with remote_file with cookie header
- **[#110](https://github.com/socrata-cookbooks/java/pull/110)** - Update openjdk to use the alternatives resource

v1.17.2
-------
### Bug
- **[COOK-4136](https://tickets.opscode.com/browse/COOK-4136)** - Add md5 parameter to java_ark resource


v1.17.0
-------
- **[COOK-4114](https://tickets.opscode.com/browse/COOK-4114)** - Test Kitchen no longer works after merging Pull Request #95 for openjdk tests on Debian/Ubuntu
- **[COOK-4124](https://tickets.opscode.com/browse/COOK-4124)** - update-alternatives fails to run
- **[#81](https://github.com/socrata/java/pull/81)** - Ensure local directory hierarchy
- **[#97](https://github.com/socrata/java/pull/97)** - Expose LWRP state attributes
- **[#99](https://github.com/socrata/java/pull/99)** - support for MD5 checksum
- **[#106](https://github.com/socrata/java/pull/106)** - Fixed windows case to prevent bad java_home variable setting
- **[Update checksums to the officially-published ones from Oracle](https://github.com/socrata/java/commit/b9e1df24caeb6e22346d2d415b3b4384f15d4ffd)**
- **[Further test kitchen fixes to use the default recipe](https://github.com/socrata/java/commit/01c0b432705d9cfa6d2dfeaa380983e3f604069f)**

v1.16.4
-------
### Bug
- **[#103](https://github.com/socrata/java/pull/103)** - set alternatives when using ibm_tar recipe
- **[#104](https://github.com/socrata/java/pull/104)** - Specify windows attributes in attribute files

v1.16.2
-------
### Improvement
- **[COOK-3488](https://tickets.opscode.com/browse/COOK-3488)** - set alternatives for ibm jdk
- **[COOK-3764](https://tickets.opscode.com/browse/COOK-3764)** - IBM Java installer needs 'rpm' package on Ubuntu

### Bug
- **[COOK-3857](https://tickets.opscode.com/browse/COOK-3857)** - do not unescape the java windows url before parsing it
- **[#95](https://github.com/socrata/java/pull/95)** - fixes update-alternatives for openjdk installs
- **[#100](https://github.com/socrata/java/pull/100)** - Use escaped quotes for Windows INSTALLDIR


v1.16.0
-------
### Improvement
- **[COOK-3823](https://tickets.opscode.com/browse/COOK-3823)** - Upgrade to JDK 7u45-b18

v1.15.4
-------
[COOK-4210] - remove unneeded run_command to prevent zombie processes


v1.15.2
-------
[CHEF-4210] remove unneeded run_command to prevent zombie processes


v1.15.0
-------
### Bug
- Fixing version number. Accidently released at 0.15.x instead of 1.15.x


v0.15.2
-------
### FIX
- [COOK-3908] - Fixing JAVA_HOME on Ubuntu 10.04


v1.14.0
-------
### Bug
- **[COOK-3704](https://tickets.opscode.com/browse/COOK-3704)** - Fix alternatives when the package is already installed
- **[COOK-3668](https://tickets.opscode.com/browse/COOK-3668)** - Fix a condition that would result in an error executing action `run` on resource 'bash[update-java-alternatives]'
- **[COOK-3569](https://tickets.opscode.com/browse/COOK-3569)** - Fix bad checksum length
- **[COOK-3541](https://tickets.opscode.com/browse/COOK-3541)** - Fix an issue where Java cookbook installs both JDK 6 and JDK 7 when JDK 7 is specified
- **[COOK-3518](https://tickets.opscode.com/browse/COOK-3518)** - Allow Windoes recipe to download from signed S3 url
- **[COOK-2996](https://tickets.opscode.com/browse/COOK-2996)** - Fix a failure on Centos 6.4 and Oracle JDK 7

### Improvement
- **[COOK-2793](https://tickets.opscode.com/browse/COOK-2793)** - Improve Windows support


v1.13.0
-------
### Bug
- **[COOK-3295](https://tickets.opscode.com/browse/COOK-3295)** - Add default `platform_family` option in Java helper
- **[COOK-3277](https://tickets.opscode.com/browse/COOK-3277)** - Fix support for Fedora

### Improvement
- **[COOK-3278](https://tickets.opscode.com/browse/COOK-3278)** - Upgrade to Oracle Java 7u25
- **[COOK-3029](https://tickets.opscode.com/browse/COOK-3029)** - Add Oracle RPM support
- **[COOK-2931](https://tickets.opscode.com/browse/COOK-2931)** - Add support for the platform `xenserver`
- **[COOK-2154](https://tickets.opscode.com/browse/COOK-2154)** - Add SmartOS support

v1.12.0
-------
### Improvement
- [COOK-2154]: Add SmartOS support to java::openjdk recipe
- [COOK-3278]: upgrade to Oracle Java 7u25

### Bug
- [COOK-2931]: Adding support for the platform 'xenserver' (for installations of java in DOM0)
- [COOK-3277]: java cookbook fails on Fedora

v1.11.6
-------
### Bug
- [COOK-2847]: Java cookbook does not have opensuse support
- [COOK-3142]: Syntax Errors spec/default_spec.rb:4-8

v1.11.4
-------
### Bug
- [COOK-2989]: `bash[update-java-alternatives]` resource uses wrong attribute

v1.11.2
-------
### Bug
- Use SHA256 checksums for Oracle downloads, not SHA1.

v1.11.0
-------
This version brings a wealth of tests and (backwards-compatible) refactoring, plus some new features (updated Java, IBM recipe).

### Sub-task
- [COOK-2897]: Add ibm recipe to java cookbook
- [COOK-2903]: move java_home resources to their own recipe
- [COOK-2904]: refactor ruby_block "update-java-alternatives"
- [COOK-2905]: use platform_family in java cookbook
- [COOK-2920]: add chefspec to java cookbook

### Task
- [COOK-2902]: Refactor java cookbook

### Improvement
- [COOK-2900]: update JDK to JDK 7u21, 6u45

v1.10.2
-------
- [COOK-2415] - Fixed deprecation warnings in ark provider and openjdk recipe by using Chef::Mixin::ShellOut instead of Chef::ShellOut

v1.10.0
-------
- [COOK-2400] - Allow java ark :url to be https
- [COOK-2436] - Upgrade needed for oracle jdk in java cookbook

v1.9.6
------
- [COOK-2412] - add support for Oracle Linux

v1.9.4
------
- [COOK-2083] - Run set-env-java-home in Java cookbook only if necessary
- [COOK-2332] - ark provider does not allow for *.tgz tarballs to be used
- [COOK-2345] - Java cookbook fails on CentOS6 (update-java-alternatives)

v1.9.2
------
- [COOK-2306] - FoodCritic fixes for java cookbook

v1.9.0
------
- [COOK-2236] - Update the Oracle Java version in the Java cookbook to release 1.7u11

v1.8.2
------
- [COOK-2205] - Fix for missing /usr/lib/jvm/default-java on Debian

v1.8.0
------
- [COOK-2095] - Add windows support

v1.7.0
------
- [COOK-2001] - improvements for Oracle update-alternatives
  - When installing an Oracle JDK it is now registered with a higher
    priority than OpenJDK. (Related to COOK-1131.)
  - When running both the oracle and oracle_i386 recipes, alternatives
    are now created for both JDKs.
  - Alternatives are now created for all binaries listed in version
    specific attributes. (Related to COOK-1563 and COOK-1635.)
  - When installing Oracke JDKs on Ubuntu, create .jinfo files for use
    with update-java-alternatives. Commands to set/install
    alternatives now only run if needed.

v1.6.4
------
- [COOK-1930] - fixed typo in attribute for java 5 on i586

v1.6.2
------
- whyrun support in `java_ark` LWRP
- CHEF-1804 compatibility
- [COOK-1786]- install Java 6u37 and Java 7u9
- [COOK-1819] -incorrect warning text about `node['java']['oracle']['accept_oracle_download_terms']`

v1.6.0
------
- [COOK-1218] - Install Oracle JDK from Oracle download directly
- [COOK-1631] - set JAVA_HOME in openjdk recipe
- [COOK-1655] - Install correct architecture on Amazon Linux

v1.5.4
------
- [COOK-885] - update alternatives called on wrong file
- [COOK-1607] - use shellout instead of execute resource to update alternatives

v1.5.2
------
- [COOK-1200] - remove sun-java6-jre on Ubuntu before installing Oracle's Java
- [COOK-1260] - fails on Ubuntu 12.04 64bit with openjdk7
- [COOK-1265] - Oracle Java should symlink the jar command

v1.5.0
------
- [COOK-1146] - Oracle now prevents download of JDK via non-browser
- [COOK-1114] - fix File.exists?

v1.4.2
------
- [COOK-1051] - fix attributes typo and platform case switch consistency

v1.4.0
------
- [COOK-858] - numerous updates: handle jdk6 and 7, switch from sun to oracle, make openjdk default, add `java_ark` LWRP.
- [COOK-942] - FreeBSD support
- [COOK-520] - ArchLinux support
