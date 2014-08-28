# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # In general, it is a good idea to use latest release of Chef 11.x,
  # but please keep in mind that Travis team is provisioning with the version defined at
  # https://github.com/travis-ci/travis-images/blob/master/lib/travis/cloud_images/vm_provisioner.rb
  config.omnibus.chef_version = :latest

  # Enable Vagrant plugins like vagrant-cachier and vagrant-vbguest
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end
  # if Vagrant.has_plugin?("vagrant-vbguest")
  #   config.vbguest.auto_update = true
  # end

  # VM tuning hints:
  # - A big VM (RAM > 1024M) is recommended to speed up compilation/install time
  # - A small VM (RAM < 1024M) is usually enough to verify a little set of isolated cookbooks
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 4
  end

  config.vm.provider "vmware_fustion" do |v|
    v.vmx["memsize"]  = 6144
    v.vmx["numvcpus"] = 2
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # The Travis CI Linux worker is currently based on Ubuntu 12.04LTS 64bit
  # Pending: Refer to a basebox with Linux Kernel pinned on version 2.6
  config.vm.define :precise64, primary: true do |ubuntu|
    ubuntu.vm.box = "ubuntu/precise64"
  end

  # Work in Progress: Support of Ubuntu 14.04LTS (not supported yet)
  config.vm.define :trusty64, autostart: false do |ubuntu|
    ubuntu.vm.box = "ubuntu/trusty64"
  end

  # Work in Progress: Support of Windows 8 (not supported yet)
  config.vm.define :win8, autostart: false do |win|
    win.vm.box = "win8"
    win.vm.communicator = "winrm"
    win.vm.guest = :windows

    # Port forward WinRM and RDP
    win.vm.network :forwarded_port, guest: 3389, host: 3389
    win.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true

    win.vm.provider "virtualbox" do |v|
      v.gui = true # not necessary, but I like spying on Windows while I'm getting things figured out
    end
  end

  templates_dir = '../travis-images/templates'

  if File.exists? templates_dir
    template_config config, templates_dir
  else
    manual_config config
  end

end

# configure VM based on templates
def template_config(config, templates_dir)
  templates = Dir.glob(File.join(templates_dir, "worker.*.yml")).map { |path| TravisImageTemplate.new path }

  tempalte_groups   = templates.group_by { |template| template.name == 'standard' }
  standard_template = tempalte_groups[true].first # there is only one!
  other_templates   = tempalte_groups[false]

  other_templates.each do |template|
    # template.data.merge!({ 'json' => { 'travis_build_environment' => { 'user' => 'vagrant'} } })

    config.vm.define template.name, autostart: false do |worker|

      worker.vm.box = 'travis-precise'
      worker.ssh.username = 'travis'

      worker.vm.provision "chef_solo" do |chef|
        chef.log_level = :info
        chef.cookbooks_path = "ci_environment"

        chef.merge(template)

        (standard_template.data['recipes'] + template.data['recipes']).each { |recipe| chef.add_recipe recipe }
      end
    end
  end
end

def manual_config(config)
  config.vm.provision "chef_solo" do |chef|
    chef.log_level      = :info
    chef.cookbooks_path = "ci_environment"

    # Role-based Provisioning:
    chef.roles_path = "roles"
    chef.add_role "worker_standard"

    # Alternatively, you can disable `chef.add_role` above and specify a smaller run list:
    # chef.add_recipe "apt"
    # chef.add_recipe "travis_build_environment"
    # chef.add_recipe "java"
    # chef.add_recipe "..."
    #
    # chef.json = {
    #   "apt" => {
    #     :mirror => 'de'
    #   },
    #   "travis_build_environment" => {
    #     "user" => 'vagrant'
    #   },
    # }
  end
end

# Wrapper for template data in travis-images
class TravisImageTemplate
  # #run_list and #json are necessary for an instance
  # of this class to be passed via #merge

  attr_reader :name, :data, :run_list

  def initialize(path)
    @path = path
    path =~ /worker\.(.+)\.yml$/
    @name = $1

    @data = YAML.load File.read path

    @run_list = []
  end

  def json
    data['json'] || {}
  end
end
