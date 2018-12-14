# frozen_string_literal: true

name 'travis_java'
maintainer 'Travis CI GmbH'
maintainer_email 'contact+travis-cookbooks-travis-java@travis-ci.org'
license 'MIT'
description 'Installs different Java Development Kits (JDK)'
issues_url 'https://github.com/travis-ci/travis-cookbooks/issues'
source_url 'https://github.com/travis-ci/travis-cookbooks/master/cookbooks/travis_java'
version '3.0.0'
chef_version '~> 13' if respond_to?(:chef_version)

depends 'apt'
depends 'travis_build_environment'
