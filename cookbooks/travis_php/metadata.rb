# encoding: utf-8

name 'travis_php'
maintainer 'Loïc Frering'
maintainer_email 'loic.frering@gmail.com'
license 'Apache 2.0'
description 'Installs php-build and phpenv for multiple PHP versions management.'
version '1.0.0'

depends 'apt'
depends 'build-essential'

depends 'phpunit'
depends 'composer'
depends 'travis_phpbuild'
depends 'travis_phpenv'

depends 'hhvm'
