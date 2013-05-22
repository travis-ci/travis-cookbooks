source 'https://rubygems.org'

gem 'rake'

group :test do
  gem 'foodcritic', '~> 2.1.0'
end

group :integration do
  #gem 'test-kitchen', '~> 1.0.0.alpha.6' 
  #gem 'test-kitchen', :git => 'https://github.com/opscode/test-kitchen.git', :ref => '101b525a9168517ae315829088070993327c9eba'

  # Patched version required to:
  #  - fetch cookbooks in non-standard location ('ci_environment' directory)
  #  - provision within 'bash -l' to get PATH extended with /etc/profile.d scripts (only required by travis base boxes)
  gem 'test-kitchen', :git => 'https://github.com/gildegoma/test-kitchen.git', :branch => 'dirty_hacks_for_travisci_poc'

  #gem 'kitchen-vagrant', '~> 0.10.0' 
  
  # Patched version required if vagrant 'user' and 'ssh_key' default values must be overidden (only required by travis base boxes)
  # see https://github.com/opscode/kitchen-vagrant/pull/23 and https://github.com/opscode/kitchen-vagrant/pull/24
  gem 'kitchen-vagrant', :git => 'https://github.com/gildegoma/kitchen-vagrant.git', :branch => 'patch_integration'
end
