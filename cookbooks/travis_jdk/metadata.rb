# frozen_string_literal: true

name 'travis_jdk'
maintainer 'Travis CI GmbH'
maintainer_email 'contact+travis-cookbooks-travis-java@travis-ci.org'
license 'All Rights Reserved'
description 'Installs/Configures travis_jdk'
version '0.1.0'
chef_version '>= 12.1'
issues_url 'https://github.com/travis-ci/travis-cookbooks/issues'
source_url 'https://github.com/travis-ci/travis-cookbooks/master/cookbooks/travis-jdk'

depends 'travis_build_environment'
