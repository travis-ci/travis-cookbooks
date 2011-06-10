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
        chef.cookbooks_path = "/path/to/your/cookbooks"
        chef.add_recipe "rvm" # Adds a required recipe
      end
    end

## License

See LICENSE file.