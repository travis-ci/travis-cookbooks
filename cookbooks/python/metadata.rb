name              "python"
# maintainer        "Opscode, Inc."
# maintainer_email  "cookbooks@opscode.com"
maintainer        "Travis CI GmbH"
maintainer_email  "contact+travis-cookbooks-python@travis-ci.org"
license           "Apache 2.0"
description       "Installs Python, pip and virtualenv. Includes LWRPs for managing Python packages with `pip` and `virtualenv` isolated Python environments."
version           "1.0.2"

%w{ debian ubuntu centos redhat fedora }.each do |os|
  supports os
end

%w{ apt build-essential pypy }.each do |cb|
  depends cb
end

recipe "python", "Installs python, pip, and virtualenv"
recipe "python::package", "Installs python using packages."
recipe "python::pyenv", "Installs python using pyenv's python-build."
recipe "python::source", "Installs python from source."
recipe "python::pip", "Installs pip from source."
recipe "python::virtualenv", "Installs virtualenv using the python_pip resource."
