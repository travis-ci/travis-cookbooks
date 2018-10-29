# frozen_string_literal: true

default['travis_phpenv']['prerequisite_recipes'] = %w[git]
default['travis_phpenv']['git']['repository'] = 'git://github.com/CHH/phpenv.git'
default['travis_phpenv']['git']['revision'] = '44f89b8d124386d9920a2ae747caff288cf4d64c'
