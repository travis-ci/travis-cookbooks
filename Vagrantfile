# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.omnibus.chef_version = :latest

  config.vm.define :win8 do |win|
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

  config.vm.define :precise do |ubuntu|
    ubuntu.vm.box = "hashicorp/precise64"
  end

  config.vm.define :trusty do |ubuntu|
    ubuntu.vm.box = "ubuntu/trusty64"
  end
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # We're gonna need a bigger VM or the compilation/installs will take forever!
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 4
  end

  config.vm.provision "chef_solo" do |chef|
    chef.log_level      = :info
    chef.cookbooks_path = "ci_environment"
    chef.roles_path = "roles"
    chef.add_role "worker_standard"
  end
end
