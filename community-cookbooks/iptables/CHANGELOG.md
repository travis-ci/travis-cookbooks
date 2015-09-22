v1.0.0 (2015-04-29)
--------------------------

NOTE: This release includes breaking changes to the behavior of this cookbook.
The iptables_rule definition was converted to a LWRP.  This changes the behavior
of disabling iptables rules.  Previously a rule could be disabled by specifying
`enable false`.  You must now specify `action :disable`.  Additionally the cookbook
no longer installs the out of the box iptables rules.  These were rules made assumptions
about the operating environment and should not have been installed out of the box.
This makes this recipe a library cookbook that can be better wrapped to meet the needs
or your particular environment.

- Definition converted to a LWRP to providing why-run support and
- The out of the box iptables rules are no longer installed.  If you need these rules you'll need to wrap the cookbook and use the LWRP to define these same rules.
- Removed all references to the roadmap and deprecation of the cookbook.  It's not going anywhere any time soon
- Use platform_family to better support Debian derivatives
- Converted file / directory modes to strings to preserve the leading 0
- Added additional RHEL derivitive distributions to the metadata
- Expanded excluded files in the gitignore and chefignore files
- Included the latest contributing documentation to match the current process

v0.14.1 (2015-01-01)
--------------------
- Fixing File.exists is deprecated for File.exist

v0.14.0 (2014-08-31)
--------------------
- [#14] Adds basic testing suite including Berksfile
- [#14] Adds basic integration/post-converge tests
- [#14] Adds default prefix and postfix rules to disalow traffic

v0.13.2 (2014-04-09)
--------------------
- [COOK-4496] Added Amazon Linux support


v0.13.0 (2014-03-19)
--------------------
- [COOK-3927] Substitute Perl version of rebuild-iptables with Ruby version


v0.12.2 (2014-03-18)
--------------------
- [COOK-4411] - Add newling to iptables.snat


v0.12.0
-------
- [COOK-2213] - iptables disabled recipe

v0.11.0
--------
- [COOK-1883] - add perl package so rebuild script works

v0.10.0
-------
- [COOK-641] - be able to save output on rhel-family
- [COOK-655] - use a template from other cookbooks

v0.9.3
------
- Current public release.
