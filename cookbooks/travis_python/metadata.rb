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
depends 'travis_build_environment'

recipe 'travis_python', 'Installs python, pip, and virtualenv'
recipe 'travis_python::package', 'Installs python using packages.'
recipe 'travis_python::pip', 'Installs pip from source.'
recipe 'travis_python::pyenv', "Installs python using pyenv's python-build."
recipe 'travis_python::source', 'Installs python from source.'
recipe 'travis_python::virtualenv', 'Installs virtualenv using the python_pip resource.'
