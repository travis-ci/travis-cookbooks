packagecloud
===============
This is the Changelog for the packagecloud cookbook

v0.2.4 (2016-07-05)
-------------------
Add `proxy_host` and `proxy_port` attributes so that the cookbook can contact the
packagecloud server.

v0.2.3 (2016-06-01)
-------------------
Try to fix `metadata_expire` type (set as String)

v0.2.2 (2016-06-01)
-------------------
Try to fix `metadata_expire` type (set as Integer)

v0.2.1 (2016-05-31)
-------------------
Set `metadata_expire` option to default of 300 (5 minutes) to match the
generated configs produced by the bash and manual install instructions.


v0.2.0 (2016-02-17)
-------------------
Rework GPG paths to support new GPG endpoints for repos with repo-specific GPG
keys. Old endpoints/URLs still work, too.

v0.1.0 (2015-09-08)
-------------------
packagecloud cookbook versions 0.0.19 used an attribute called
`default['packagecloud']['hostname']` for caching the local machine's hostname
to avoid regenerating read tokens.

This attribute has been removed as it is confusing and in some edge cases,
buggy.

Beginning in 0.1.0, you can use
`default['packagecloud']['hostname_override']` to specify a hostname if ohai
is unable to determine the hostname of the node on its own.

v0.0.1 (2014-06-05)
-------------------
Initial release.


v0.0.1 (2014-06-05)
-------------------
Initial release!
