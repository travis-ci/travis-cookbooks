# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

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

  config.vm.provider "vmware_fusion" do |v|
    v.vmx["memsize"]  = 2048
    v.vmx["numvcpus"] = 2
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # The Travis CI Linux worker is currently based on Ubuntu 12.04 64bit
  # Pending: Refer to a basebox with Linux Kernel pinned on version 2.6
  config.vm.define :precise64, primary: true do |ubuntu|
    ubuntu.vm.box = "ubuntu/precise64"
  end

  # Work in Progress: Support of Ubuntu 14.04 64bit (not supported yet)
  # Pull requests are welcome on https://github.com/travis-ci/travis-cookbooks/tree/ha-feature-trusty branch
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

  %w(precise trusty).each do |rel|
    template_config config, rel, 'vm_templates'
  end

end

# configure VM based on templates
def template_config(config, release, templates_dir)
  templates = Dir.glob(File.join(templates_dir, "**/*.yml")).map { |path| TravisImageTemplate.new path }

  template_groups = templates.group_by { |template| template.name }

  template_groups.keys.delete_if { |k| k == 'standard' }.each do |template_name|
    this_template_group = template_groups[template_name]
    base     = this_template_group.select {|t| t.path =~ /\bcommon\b/}.first
    addition = this_template_group.select {|t| t.path =~ /\bstandard\b/}.first

    config.vm.define "#{template_name}-#{release}", autostart: false do |worker|
      worker.vm.box = "travis-#{release}"
      worker.ssh.username = 'travis'
      worker.ssh.password = 'travis'

      worker.vm.provision "chef_solo" do |chef|
        chef.log_level = :info
        chef.cookbooks_path = "ci_environment"

        chef.merge(base)

        if addition
          chef.json = base.json.deep_merge(addition.json).merge({'system_info' => {'cookbooks_sha' => `cd ../travis-cookbooks; git show-ref refs/heads/master -s`.chomp}})
          Array((base.data['recipes'] || []).concat(addition.data['recipes'])).each { |recipe| chef.add_recipe recipe }
        else
          chef.json = base.json.merge({'system_info' => {'cookbooks_sha' => `cd ../travis-cookbooks; git show-ref refs/heads/master -s`.chomp}})
          Array(base.data['recipes'] || []).each { |recipe| chef.add_recipe recipe }
        end
      end
    end
  end
end

# Wrapper for template data in travis-images
class TravisImageTemplate
  # #run_list and #json are necessary for an instance
  # of this class to be passed via #merge

  attr_reader :path, :name, :data, :run_list

  def initialize(path)
    @path = path
    path =~ /([^\/]+)\.yml$/
    @name = $1

    @data = YAML.load File.read(path)

    @run_list = []
  end

  def json
    data['json'] || {}
  end

  def to_s
    "name: #{name}\npath: #{path}\njson: #{json}\nrecipes: #{data['recipes']}"
  end
end
