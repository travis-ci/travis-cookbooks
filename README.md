# About Travis cookbooks

Travis cookbooks are collections of Chef cookbooks for setting up

 * Travis worker
 * Vagrant base VM
 * Anything else we may need to set up

## Installing inside Vagrant Box using Chef-solo, sample Vagrantfile

``` ruby
$: << 'lib'
require 'yaml'
require 'travis/worker'

config = Travis::Worker.config.vms
with_base = ENV['WITH_BASE'] == 'true'

Vagrant::Config.run do |c|
  config.vms.each_with_index do |name, num|
    next if name == 'base' && !with_base

    c.vm.define(name) do |c|
      c.vm.box = name == 'base' ? 'base' : "worker-#{num}"
      c.vm.forward_port('ssh', 22, 2220 + num)

      c.vm.customize do |vm|
        vm.memory_size = config.memory.to_i
      end

      if config.recipes?
        c.vm.provision :chef_solo do |chef|
          chef.cookbooks_path = config.cookbooks
          chef.log_level = :debug # config.log_level

          config.recipes.each do |recipe|
            chef.add_recipe(recipe)
          end

          chef.json.merge!(config.json)
        end
      end
    end
  end
end
```

then in .worker.yml, add :vms section that lists the cookbooks you want to provision:

``` yaml
vms:
  count: 3
  base: lucid32
  memory: 1536
  cookbooks: 'vendor/cookbooks/vagrant_base'
  json:
    rvm:
      rubies:
        - 1.8.6
        - 1.8.7
        - 1.8.7-p174
        - 1.8.7-p249
        - 1.9.2
        - 1.9.1-p378
        - jruby
        - rbx
        - rbx-2.0.0pre
        - ree
        - ruby-head
      gems:
        - bundler
        - rake
        - chef
      aliases:
        rbx-2.0.0pre: rbx-2.0
        1.9.1-p378:   1.9.1
    mysql:
      server_root_password: ""
    postgresql:
      max_connections: 256
  recipes:
    - travis_build_environment
    - apt
    - build-essential
    - scons
    - networking_basic
    - openssl
    - sysctl
    - libyaml # libyaml MUST be installed before rubies. MK.
    - emacs::nox
    - vim
    - timetrap
    - git
    - java::openjdk
    - libqt4
    - libv8
    - nodejs
    - rvm
    - rvm::multi
    - sqlite
    - postgresql::client
    - postgresql::server
    - redis
    - mysql::client
    - mysql::server
    - mongodb
    - memcached
    - rabbitmq
    - imagemagick
```

## License

See LICENSE file.
