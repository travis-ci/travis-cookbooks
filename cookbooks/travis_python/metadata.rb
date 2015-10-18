name 'travis_python'
maintainer 'Travis CI GmbH'
maintainer_email 'contact+travis-cookbooks-python@travis-ci.org'
license 'Apache 2.0'
description 'Installs Python, pip and virtualenv'
version '2.0.0'

supports 'debian'
supports 'ubuntu'

depends 'apt'
depends 'build-essential'
depends 'poise-python'
depends 'pypy'
depends 'travis_build_environment'

recipe 'travis_python', 'No-op!'
recipe 'travis_python::pyenv', "Installs python using pyenv's python-build."
recipe 'travis_python::system', 'Installs system python and other stuff.'
recipe 'travis_python::devshm', 'Goofs around with /dev/shm maybe.'
