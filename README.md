# About Travis cookbooks

Travis cookbooks are collections of Chef cookbooks for setting up

 * VMs for running tests (CI environment)
 * Travis worker machine (host OS)
 * Anything else we may need to set up (for example, messaging broker nodes)


## Other VM infrastructure projects

Travis cookbooks are now part of a larger project that travis-ci.org developers use to create VM images for our CI environment.
It is called [travis-boxes](https://github.com/travis-ci/travis-boxes).


## Developing Cookbooks

Cookbooks are developed using Vagrant with [Sous Chef](https://github.com/michaelklishin/sous-chef) and packaged for
production using [travis-boxes](https://github.com/travis-ci/travis-boxes).
See those projects for more information.

Please note that from December 2011 and going forward, *Chef cookbooks must be Ruby 1.9.2-compatible* because we switched to Ruby 1.9.2 for running Chef
during provisioning.


## License

See the LICENSE file.
