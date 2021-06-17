# frozen_string_literal: true

name 'travis_build_environment'
maintainer 'Travis CI Development Team'
maintainer_email 'contact+travis-cookbooks-travis-build-environment@travis-ci.org'
license 'Apache-2.0'
version '1.1.0'
description 'Travis build environment'
long_description 'Travis build environment'
issues_url 'https://github.com/travis-ci/travis-cookbooks/issues'
source_url 'https://github.com/travis-ci/travis-cookbooks/master/cookbooks/travis_build_environment'
chef_version '~> 13' if respond_to?(:chef_version)

depends 'apt'
depends 'ark'
depends 'iptables'
depends 'packagecloud'
depends 'travis_groovy'
depends 'travis_phpenv'
