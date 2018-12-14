# frozen_string_literal: true

name 'travis_users'
maintainer 'Travis CI GmbH'
maintainer_email 'contact+users-cookbook@travis-ci.com'
license 'MIT'
description 'Configures users for Travis CI servers'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url 'https://github.com/travis-ci/travis-cookbooks/issues'
source_url 'https://github.com/travis-ci/travis-cookbooks/master/cookbooks/travis_users'
version '0.2.0'
chef_version '>= 13.8' if respond_to?(:chef_version)
