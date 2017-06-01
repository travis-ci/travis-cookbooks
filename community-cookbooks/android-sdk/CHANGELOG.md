CHANGELOG for Android-SDK cookbook
==================================

v0.2.2 (2017-05-28)
-------------------

- Fix compatibility error with Chef 13.x [GH-40]
  The `Chef::Resource::Script#path` property [has been removed in Chef 13](https://docs.chef.io/release_notes.html#the-path-property-of-the-execute-resource-has-been-removed).

v0.2.1 (2017-03-04)
-------------------

- Add support for Android SDK 25 (but without integration of the `sdkmanager` command) [GH-34]
- Download all the SDK Tools packages from the new HTTPS-based repository.
  Note that the packages are now .zip files (and no longer available as .tgz).
- Chef 12.5+ is now required to run this cookbook and its dependencies

v0.2.0 (2015-10-17)
-------------------

- Integrate by default with Android SDK 24.4.0 (October 2015)
- Add the `java_from_system` option to skip java cookbook dependency (disabled by default)
- Add the `set_environment_variables` option to automatically set related environment variables
  in user shell (enabled by default)
- Add the `with_symlink` option to use ark's friendly symlink feature (enabled by default)
- Deploy scripts for waiting on Emulator startup [GH-16]
- Deploy scripts for non-interactive SDK setup/updates [GH-13]
- Add Rubocop checks [GH-7]
- Optionally install Maven Android SDK Deployer [GH-14]

v0.1.1 (2014-04-01)
-------------------

- No code changes compared to v0.1.0
- Fixed community packaging (Stove included ~ backup files in v0.1.0 tarball)
- Minor fixes (typo and lint errors)

v0.1.0 (2014-03-31)
-------------------

- Accept or Reject some SDK licenses with expect [GH-11]
- Add a basic idempotent guard [GH-10]
- Accept all SDK licenses with expect [GH-3]
- Support for Ubuntu 12.04+ (32bit and 64bit) [GH-1]
- Integrate by default with Android SDK 22.6.2

v0.0.0 (2013-08-08)
-------------------

*First Draft*

