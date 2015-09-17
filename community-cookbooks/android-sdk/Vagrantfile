Vagrant.configure("2") do |config|

  #
  # Vagrant Base Box and virutal hardware tuning
  #

  #config.vm.box       = "ubuntu/precise64"
  config.vm.box       = "ubuntu/trusty64"

  config.vm.provider :virtualbox do |p|
    p.customize ["modifyvm", :id, "--memory", 768]
  end

  #
  # Vagrant Plugins:
  #
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end
  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true

  #
  # Chef Provisioning
  #
  config.vm.provision :chef_solo do |chef|

    #chef.log_level = 'debug'

    chef.add_recipe 'apt'
    chef.add_recipe 'git'
    chef.add_recipe 'maven'

    chef.add_recipe 'android-sdk'

    chef.json = {
      "java" => {
        "jdk_version" => '7'
      },
      "android-sdk" => {
        "owner" => 'vagrant',
        "group" => 'vagrant',
#        "components" => ['android-20', 'android-19']
        "maven-rescue" => true,
        "maven-local-repository" => '/home/vagrant/.m2/repository'
      },
    }
  end

end
