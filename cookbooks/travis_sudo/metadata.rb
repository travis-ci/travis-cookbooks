# frozen_string_literal: true

name 'travis_sudo'
maintainer 'Travis CI GmbH'
maintainer_email 'contact+travis-cookbooks-travis-sudo@travis-ci.org'
license 'MIT'
description 'Installs/Configures sudo, groups, users, :boom:'
issues_url 'https://github.com/travis-ci/travis-cookbooks/issues'
source_url 'https://github.com/travis-ci/travis-cookbooks/master/cookbooks/travis_sudo'
version '0.2.0'
chef_version '>= 13.8' if respond_to?(:chef_version)
