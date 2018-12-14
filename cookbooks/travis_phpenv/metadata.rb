# frozen_string_literal: true

name 'travis_phpenv'
maintainer 'Loïc Frering'
maintainer_email 'loic.frering@gmail.com'
license 'Apache 2.0'
description 'Installs phpenv for multiple PHP versions switching. phpenv is based on rbenv.'
issues_url 'https://github.com/travis-ci/travis-cookbooks/issues'
source_url 'https://github.com/travis-ci/travis-cookbooks/master/cookbooks/travis_phpenv'
version '1.0.0'
chef_version '>= 13.8' if respond_to?(:chef_version)

depends 'git'
depends 'travis_build_environment'
