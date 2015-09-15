# Travis cookbooks!

Travis cookbooks are collections of Chef cookbooks used with
[Chef](https://www.chef.io/) for setting up:

 * Linux VMs for running tests (CI environment in `./ci_environment`)
 * Travis worker machine (host OS in `./worker_host`)

The wrapper cookbooks that compose together the cookbooks found here live over
in the [Travis CI Infrastructure Packer
Templates](https://github.com/travis-infrastructure/packer-templates)
repository.

## Developing Cookbooks

### Requirements

All the required cookbooks are stored in this single repository (no
Berkshelf/Librarian, no git modules). You can find more details about this
approach in ["Making Breakfast: Chef at
Airbnb"](http://nerds.airbnb.com/making-breakfast-chef-airbnb/).

There is no `Gemfile` for specifying Chef dependencies.  Please install the
[ChefDK](https://downloads.chef.io/chef-dk/).

### Branches

There are two long-lived branches:

- `master` per tradition, which is compatible with **Ubuntu 14.04**
- `precise-stable`, which is compatible with **Ubuntu 12.04**

Please target your patches accordingly.

## License

See the LICENSE files.
