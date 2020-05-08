[![Build Status](https://travis-ci.com/travis-ci/travis-cookbooks.svg?branch=master)](https://travis-ci.com/travis-ci/travis-cookbooks)

# Travis cookbooks!

Travis cookbooks are collections of Chef cookbooks used with
[Chef](https://www.chef.io/) for setting up Linux VMs for running tests and
Travis internal machines.

The wrapper cookbooks that compose together the cookbooks found here live over
in the [Travis CI Infrastructure Packer
Templates](https://github.com/travis-ci/packer-templates)
repository.

## Developing Cookbooks

### Directory structure

There are two cookbook path directories in this repository:

- `cookbooks` authored by Travis CI
- `community-cookbooks` vendored community stuff

### Requirements

There is no `Gemfile` for specifying Chef dependencies.  Please install the
[ChefDK](https://downloads.chef.io/chef-dk/).

### Testing

The script that's run on Travis is `./runtests`, which by default runs on the
`./cookbooks` directory.  Example usage:

``` bash
./runtests
```

Any change to the cookbooks should also be tested on an actual build-VM, after building a test image.
More information on how to trigger a test image build can be found in the [packer-templates README](https://github.com/travis-ci/packer-templates#testing-cookbook-changes).


### Branches

There are two long-lived branches:

- `master` per tradition, which is compatible with **Ubuntu 16.04**
- `trusty-stable`, which is compatible with **Ubuntu 14.04**

Please target your patches accordingly.

## License

See the LICENSE files.
