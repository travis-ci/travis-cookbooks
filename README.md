# About Travis cookbooks

Travis cookbooks are collections of Chef cookbooks for setting up

 * Travis worker
 * Vagrant base VM
 * Anything else we may need to set up

## Installing inside Vagrant Box using Chef-solo, sample Vagrantfile


    Vagrant::Config.run do |config|
      config.vm.box = "lucid32"
      config.vm.box_url = "http://files.vagrantup.com/lucid32.box"

      config.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = "vendor/cookbooks/vagrant_base"

        chef.add_recipe "apt"
        chef.add_recipe "build-essential"
        chef.add_recipe "networking_basic"
        chef.add_recipe "openssl"
    
        chef.add_recipe "git"
    
        chef.add_recipe "rvm"
        chef.add_recipe "rvm::ruby_187"
        chef.add_recipe "rvm::ruby_192"
        chef.add_recipe "rvm::ree"
    
        chef.add_recipe "java::sun"
    
        chef.add_recipe "mysql::client"
        chef.add_recipe "mysql::server"
    
        chef.add_recipe "memcached"
    
        chef.add_recipe "postgresql::client"
        chef.add_recipe "postgresql::server"
    
        chef.add_recipe "redis"
        chef.add_recipe "rabbitmq"
        chef.add_recipe "mongodb::apt"
        chef.add_recipe "mongodb::server"
    
        # You may also specify custom JSON attributes:
        # chef.json.merge!({ :mysql_password => "foo" })
      end
    end

## License

See LICENSE file.
