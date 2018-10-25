# frozen_string_literal: true

name 'travis_postgresql'
maintainer 'Travis CI Team'
maintainer_email 'contact+travis-postgresql-cookbook@travis-ci.org'
license 'Apache 2.0'
description 'Installs PostgreSQL instance(s) for Continuation Integration purposes'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '3.0.0'

depends 'apt'
