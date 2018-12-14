# frozen_string_literal: true

name 'travis_docker'
maintainer 'Travis CI GmbH'
maintainer_email 'contact+travis-cookbooks-travis-docker@travis-ci.org'
license 'MIT'
version '2.0.0'
chef_version '>= 13.8' if respond_to?(:chef_version)
description 'Install ye a docker'
long_description 'No really, install docker!'
issues_url 'https://github.com/travis-ci/travis-cookbooks/issues'
source_url 'https://github.com/travis-ci/travis-cookbooks/master/cookbooks/travis_docker'

depends 'apt'
depends 'ark'
