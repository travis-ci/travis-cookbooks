# frozen_string_literal: true

name 'travis_sbt_extras'
maintainer 'Gilles Cornu'
maintainer_email 'foss@gilles.cornu.name'
license 'Apache 2.0'
description 'Installs sbt-extras to ease the building of scala projects'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url 'https://github.com/travis-ci/travis-cookbooks/issues'
source_url 'https://github.com/travis-ci/travis-cookbooks/master/cookbooks/travis_sbt_extras'
version '0.3.0'
chef_version '>= 13.8' if respond_to?(:chef_version)

depends 'travis_java'
depends 'travis_jdk'

recipe 'travis_sbt_extras::default', 'Downloads and installs sbt-extras script'
