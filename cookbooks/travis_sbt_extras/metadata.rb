# frozen_string_literal: true

name 'travis_sbt_extras'
maintainer 'Gilles Cornu'
maintainer_email 'foss@gilles.cornu.name'
license 'Apache 2.0'
description 'Installs sbt-extras to ease the building of scala projects'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.3.0'

depends 'travis_java'
depends 'travis_jdk'

recipe 'travis_sbt_extras::default', 'Downloads and installs sbt-extras script'
