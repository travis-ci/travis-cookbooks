current_version = Gem::Version.new(Chef::VERSION)

if(current_version < Gem::Version.new('10.12.0'))

  if(current_version < Gem::Version.new('0.10.9'))
    Chef::Log.info '*** Adding ChefGem Resource ***'
  else
    Chef::Log.info '*** Adding fixes to ChefGem Resource ***'
  end
  
  require 'chef/resource/gem_package'

  class Chef::Resource::GemPackage
    def gem_binary(*args)
      node ||= {}
      node[:gem_binary] || 'gem'
    end
  end

  class Chef::Resource::ChefGem < Chef::Resource::GemPackage

    #  provides :chef_gem, :on_platforms => :all

    def initialize(name, run_context=nil)
      super
      @resource_name = :chef_gem
      @provider = Chef::Provider::Package::Rubygems
      after_created
    end

    def gem_binary(*args)
      node ||= {}
      node[:chef_gem_binary] || ::File.join(Gem.bindir, 'gem')
    end

    def after_created
      Array(@action).flatten.compact.each do |action|
        self.run_action(action)
      end
      Gem.clear_paths
    end
  end
end

if(Chef::VERSION.to_s.start_with?('0.10.10'))
  Chef::Log.info '** Patching Chef::Provider::Package::Rubygems#is_omnibus? to properly find all omnibus installs **'
  class Chef::Provider::Package::Rubygems
    def is_omnibus?
      if RbConfig::CONFIG['bindir'] =~ %r!/opt/(opscode|chef)/embedded/bin!
        Chef::Log.debug("#{@new_resource} detected omnibus installation in #{RbConfig::CONFIG['bindir']}")
        # Omnibus installs to a static path because of linking on unix, find it.
        true
      elsif RbConfig::CONFIG['bindir'].sub(/^[\w]:/, '')  == "/opscode/chef/embedded/bin"
        Chef::Log.debug("#{@new_resource} detected omnibus installation in #{RbConfig::CONFIG['bindir']}")
        # windows, with the drive letter removed
        true
      else
        false
      end
    end
  end
end

if(current_version < Gem::Version.new('10.14.0'))
  module Chef3164
    def after_created(*)
      Gem.clear_paths # NOTE: Related to CHEF-3164
      super
    end
  end
  Chef::Resource::ChefGem.send(:include, Chef3164)
end
