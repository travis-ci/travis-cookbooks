Vagrant.configure('2') do |config|
  #
  # Vagrant Base Box and virutal hardware tuning
  #

  # config.vm.box = "ubuntu/precise64"
  config.vm.box = 'ubuntu/trusty64'

  config.vm.provider :virtualbox do |p|
    p.customize ['modifyvm', :id, '--memory', 768]
  end

  #
  # Vagrant Plugins:
  #
  config.cache.scope = :box if Vagrant.has_plugin?('vagrant-cachier')
  #  config.omnibus.chef_version = "11" #11.18.14 # :latest
  #  config.berkshelf.enabled = false
  #  config.berkshelf.args = ["--format json"]

  #
  # Chef Provisioning
  #
  config.vm.provision :chef_solo do |chef|
    # chef.log_level = 'debug'

    chef.add_recipe 'apt'
    chef.add_recipe 'git'
    chef.add_recipe 'maven'

    chef.add_recipe 'android-sdk'

    chef.json = {
      'java' => {
        'jdk_version' => '7'
      },
      'android-sdk' => {
        'owner' => 'vagrant',
        'group' => 'vagrant',
        'components' => ['android-20', 'android-19'],
        # 'setup_root' => '/opt/somewhere',
        # 'with_symlink' => false,
        # 'java_from_system' => true,
        'maven_rescue' => true,
        'maven_local_repository' => '/home/vagrant/.m2/repository'
      }
    }
  end
end
