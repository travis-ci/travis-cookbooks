# About Travis cookbooks

Travis cookbooks are collections of Chef cookbooks for setting up

 * VMs (CI environment)
 * Travis worker machine (host OS)
 * Messaging broker (Travis is being migrated to [amqp & RabbitMQ](http://github.com/ruby-amqp/amqp))
 * Anything else we may need to set up

## Travis-Build Migration

Travis cookbooks are now part of a larger project that travis-ci.org developers use to create VM images for Ci environment. It is called [travis-boxes](https://github.com/travis-ci/travis-boxes)
and will be at the heart of version 3 of travis-ci.org.


## Developing Cookbooks

Cookbooks are developed using Vagrant with either [travis-boxes](https://github.com/travis-ci/travis-boxes) or [Sous Chef](https://github.com/michaelklishin/sous-chef).
See those projects for more detailed instructions.

## License

See the LICENSE file.
