# frozen_string_literal: true

name 'travis_perlbrew'
# maintainer 'Magnus Holm'
# maintainer_email 'judofyr@gmail.com'
maintainer 'Travis CI GmbH'
maintainer_email 'contact+travis-cookbooks-travis-perlbrew@travis-ci.org'
license 'MIT'
description 'Installs and configures Perlbrew, optionally keeping it updated.'
issues_url 'https://github.com/travis-ci/travis-cookbooks/issues'
source_url 'https://github.com/travis-ci/travis-cookbooks/master/cookbooks/travis_perlbrew'
version '1.0'
chef_version '>= 13.8' if respond_to?(:chef_version)

depends 'apt'
depends 'build-essential'
depends 'travis_build_environment'

recipe 'travis_perlbrew', 'Install system-wide Perlbrew'
recipe 'travis_perlbrew::multi', 'Install a Perl implementation based on attributes'
