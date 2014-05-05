# About Travis cookbooks

Travis cookbooks are collections of Chef cookbooks used with [Chef Solo](http://docs.opscode.com/chef_solo.html) for setting up

 * Linux VMs for running tests (CI environment)
 * Travis worker machine (host OS)
 * Anything else we may need to set up (for example, messaging broker nodes)

The Chef `run-lists` that are used to build the different VM images for Travis CI environment are stored in [travis-images](https://github.com/travis-ci/travis-images/tree/master/templates) repository.

## Developing Cookbooks

### Requirements

All the required cookbooks are stored in this single repository (no Berkshelf/Librarian, no git modules). You can find more details about this approach in ["Making Breakfast: Chef at Airbnb"](http://nerds.airbnb.com/making-breakfast-chef-airbnb/).

* Chef cookbooks currently must be compatible with **Chef 11**.
* The VM template/basebox must be installed with **Ubuntu 12.04LTS**

### Virtualization Technology

At the moment, Travis Linux workers are paravirtualized machines that live in an OpenVZ container equipped with Linux kernel 2.6.32.
Please keep this in mind when testing with Linux kernel 3.x on full virtual machine (e.g. providers like VirtualBox or VMware).

### Vagrant

Cookbooks can be easily developed using [Vagrant](https://github.com/mitchellh/vagrant) with [Sous Chef](https://github.com/michaelklishin/sous-chef) workflow.

Here is an example of `Vagrantfile` that can be used with Vagrant 1.5+:

```ruby
Vagrant.configure("2") do |config|

  # Use Official Ubuntu Server 12.04 LTS daily builds from Canonical
  config.vm.box = "ubuntu/precise64"

  # Optionally enable Vagrant plugins like vagrant-cachier and vagrant-vbguest
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = true
  end

  # Tune virtual hardware
  config.vm.provider :virtualbox do |p|
    p.customize ["modifyvm", :id, "--memory", 2048]
  end

  # Install Chef if not present in the Vagrant basebox
  config.vm.provision :shell, :inline => <<EOS
set -e
if ! command -V chef-solo >/dev/null 2>/dev/null; then
  sudo apt-get update -qq
  sudo apt-get install -qq curl
  curl -L https://www.opscode.com/chef/install.sh | bash -s -- -v 11.12.2
fi
EOS

  # Provision with Chef Solo
  # See also the exact composition of Travis VMs at
  # https://github.com/travis-ci/travis-images/tree/master/templates
  config.vm.provision :chef_solo do |chef|
    chef.log_level      = :info
    chef.cookbooks_path = [ "ci_environment" ]

    chef.add_recipe 'apt'
    chef.add_recipe 'travis_build_environment'

    # The cookbooks being developed:
    chef.add_recipe 'git::ppa'
    chef.add_recipe 'java'
    chef.add_recipe 'postgresql'
    chef.add_recipe 'elasticsearch'

    chef.add_recipe 'sweeper'

    chef.json = {
      "apt" => {
        :mirror => 'de'
      },
      "travis_build_environment" => {
        "user" => 'vagrant'
      },
      "postgresql" => {
        "default_version" => '9.3',
        "alternate_versions" => []
      },
      "elasticsearch" => {
        "version" => '1.1.0'
      },
    }
  end

end
```

## General Purpose Cookbooks

Some of the cookbooks integrated in this repository are maintained upstream in individual Github repositories. Here is a non exhaustive list:

* [Ark](https://github.com/opscode-cookbooks/ark)
* [Android SDK](https://github.com/gildegoma/chef-android-sdk)
* [Cassandra](https://github.com/michaelklishin/cassandra-chef-cookbook)
* [Clang](https://github.com/michaelklishin/clang-chef-cookbook)
* [Gradle](https://github.com/michaelklishin/gradle-chef-cookbook)
* [Maven](https://github.com/opscode-cookbooks/maven)
* [Neo4J](https://github.com/michaelklishin/neo4j-server-chef-cookbook)
* [sbt](https://github.com/gildegoma/chef-sbt-extras)

## License

See the LICENSE files.

