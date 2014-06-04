source 'https://rubygems.org'

gem 'rake'
gem 'berkshelf'

group :test do
  gem 'foodcritic', '~> 2.2.0'
  gem 'chefspec', '~> 2.0.1'
  gem 'rubocop', '~> 0.18'
  gem 'rainbow', '< 2.0'
  gem 'test-kitchen'
  gem 'kitchen-vagrant'
  gem 'strainer', :github => 'customink/strainer'
  gem 'serverspec'
  # Serverspec examples use "its" which is deprecated... we can switch to an rspec 3 syntax or use the rspec-its gem
  gem 'rspec-its'
  gem 'winrm'
  # kitchen-driver-vagrant_provision is a workaround for https://github.com/test-kitchen/kitchen-vagrant/issues/77#issuecomment-40939023
  gem 'kitchen-driver-vagrant_provision'

  # Workaround: There is a ChefSpec regression when integrating with Chef 11.10+
  gem 'chef', '~> 11.8.0'
end
