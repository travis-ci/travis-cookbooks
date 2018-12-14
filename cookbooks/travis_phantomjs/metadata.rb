# frozen_string_literal: true

name 'travis_phantomjs'
maintainer 'Travis CI Development Team'
maintainer_email 'contact+travis-cookbooks-travis-phantomjs@travis-ci.org'
license 'Apache v2.0'
description 'Installs/Configures phantomjs'
issues_url 'https://github.com/travis-ci/travis-cookbooks/issues'
source_url 'https://github.com/travis-ci/travis-cookbooks/master/cookbooks/travis_phantomjs'
version '0.1.0'
chef_version '>= 13.8' if respond_to?(:chef_version)

depends 'ark'
