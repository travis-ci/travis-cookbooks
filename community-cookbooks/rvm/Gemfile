source 'https://rubygems.org'

gem 'foodcritic', '~> 3.0.3'
gem 'minitest'
gem 'rake'
gem 'rspec', '= 3.0.0'
gem 'guard-rspec'

# allow CI to override the version of Chef for matrix testing
gem 'chef', (ENV['CHEF_VERSION'] || '>= 0.10.10')

group :development do
  gem 'emeril'
end

group :integration do
  gem 'berkshelf', '~> 3.1.5'
  gem 'test-kitchen', '~> 1.2.1'
  gem 'kitchen-vagrant', '~> 0.15.0'
end
