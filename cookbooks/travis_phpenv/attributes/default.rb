# frozen_string_literal: true

default['travis_phpenv']['prerequisite_recipes'] = %w(git)
default['travis_phpenv']['git']['repository'] = 'https://github.com/travis-ci/phpenv.git'
default['travis_phpenv']['git']['revision'] = 'fb7716339914e5ff1cd9ba6a60bbc71943d96f80'
