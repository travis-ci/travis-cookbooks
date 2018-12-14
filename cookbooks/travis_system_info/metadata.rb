# frozen_string_literal: true

name 'travis_system_info'
maintainer 'Travis CI GmbH'
maintainer_email 'support@travis-ci.com'
license 'MIT License'
description 'Installs/Configures system_info'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url 'https://github.com/travis-ci/travis-cookbooks/issues'
version '0.1.0'

depends 'travis_build_environment'
