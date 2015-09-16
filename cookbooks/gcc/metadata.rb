name             'gcc'
maintainer       'Travis CI Development Team'
license          'Apache v2.0'
description      'Installs/Configures gcc/g++'
version          '0.1.0'

supports         'ubuntu'

depends          'apt'

recipe           'gcc::default',       'Installs default gcc version from platform official package repository'
recipe           'gcc::ppa',           'Installs gcc from ubuntu-toolchain-r/test PPA'

