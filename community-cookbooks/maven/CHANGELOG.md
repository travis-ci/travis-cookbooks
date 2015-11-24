maven Cookbook CHANGELOG
========================
This file is used to list changes made in each version of the maven cookbook.

v1.3.0
------
- Adding Windows support

v1.2.0
------
- Adding flag to allow Java not to be managed by cookbook

v1.1.0
------
[COOK-3849] - Update maven 3 to 3.1.1


v1.0.0
------
### Improvement
- **[COOK-3470](https://tickets.chef.io/browse/COOK-3470)** - Improve `/etc/mavenrc` template
- **[COOK-3459](https://tickets.chef.io/browse/COOK-3459)** - Install Maven 3.1.0 by default

v0.16.4
-------
### Improvement
- **[COOK-3352](https://tickets.chef.io/browse/COOK-3352)** - Improve `repository_root` attribute customization

### Bug
- **[COOK-2799](https://tickets.chef.io/browse/COOK-2799)** - Fix idempotency in LWRP

v0.16.2
-------
The following changes were originally released as 0.16.0, but the README incorrectly referred to the maven# recipes, which are now removed.

### Task
- [COOK-1874]: refactor maven default recipe to use version attributes

### Bug
- [COOK-2770]: maven cookbook broken for maven3 now that maven 3.0.5 has been released

v0.15.0
-------
- [COOK-1336] - Make Transitive Flag Configurable

v0.14.0
-------
- [COOK-2191] - maven3 recipe's "version" doesn't match the attributes
- [COOK-2208] - Add 'classifier' attribute to maven cookbook

v0.13.0
-------
- [COOK-2116] - maven should be available on the path

v0.12.0
-------
- [COOK-1860] - refactor maven provider to use resources and `shell_out`

v0.11.0
-------
- [COOK-1337] - add put action to maven lwrp to control name of the downloaded file
- [COOK-1657] - fix download urls

v0.3.0
------
- [COOK-1145] - maven lwrp to download artifacts
- [COOK-1196] - convert lwrp attributes to snake_case
- [COOK-1423] - check version attribute in default recipe

v0.2.0
------
- [COOK-813] - installs maven2 and maven3 using the binaries from maven.apache.org
