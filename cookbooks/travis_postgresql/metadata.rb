# frozen_string_literal: true

name 'travis_postgresql'
maintainer 'Travis CI Team'
maintainer_email 'contact+travis-postgresql-cookbook@travis-ci.org'
license 'Apache-2.0'
description 'Installs PostgreSQL instance(s) for Continuation Integration purposes'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url 'https://github.com/travis-ci/travis-cookbooks/issues'
source_url 'https://github.com/travis-ci/travis-cookbooks/master/cookbooks/travis_postgresql'
version '3.0.0'
chef_version '~> 13' if respond_to?(:chef_version)

depends 'apt'
