# frozen_string_literal: true

name 'travis_build_environment'
maintainer 'Travis CI Development Team'
license 'Apache-2.0'
version '1.1.0'
description 'Travis build environment'

depends 'apt'
depends 'ark'
depends 'iptables'
depends 'packagecloud'
depends 'travis_groovy'
depends 'travis_phpenv'
