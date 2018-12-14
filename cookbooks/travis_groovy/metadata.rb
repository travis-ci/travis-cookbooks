# frozen_string_literal: true

name 'travis_groovy'
maintainer 'Travis CI GmbH'
maintainer_email 'contact+travis-cookbooks-travis-groovy@travis-ci.org'
license 'MIT'
description 'Installs/Configures groovy'
issues_url 'https://github.com/travis-ci/travis-cookbooks/issues'
source_url 'https://github.com/travis-ci/travis-cookbooks/master/cookbooks/travis_groovy'
version '0.1.0'
chef_version '>= 13.8' if respond_to?(:chef_version)

depends 'ark'
