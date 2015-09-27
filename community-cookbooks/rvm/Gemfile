source 'https://rubygems.org'

gem 'rake'
gem 'foodcritic', '~> 2.2.0'
gem 'minitest'

# allow CI to override the version of Chef for matrix testing
gem 'chef', (ENV['CHEF_VERSION'] || '>= 0.10.10')

group :development do
  gem 'emeril'
end

group :integration do
  gem 'berkshelf', '~> 1.4.0'
  gem 'test-kitchen', '~> 1.0.0'
  gem 'kitchen-vagrant', '~> 0.14.0'
end
