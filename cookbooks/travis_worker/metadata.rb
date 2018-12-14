# frozen_string_literal: true

name 'travis_worker'
maintainer 'Travis CI'
maintainer_email 'contact+travis-go-worker-cookbook@travis-ci.com'
license 'MIT'
description 'Installs/Configures the Travis Go Worker'
issues_url 'https://github.com/travis-ci/travis-cookbooks/issues'
source_url 'https://github.com/travis-ci/travis-cookbooks/master/cookbooks/travis_worker'
version '0.1.0'

depends 'packagecloud'
depends 'travis_docker'
