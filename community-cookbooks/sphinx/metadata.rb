name              "sphinx"
maintainer        'Pat Allan'
maintainer_email  'pat@freelancing-gods.com'
license           'MIT'
description       'Installs stable and beta releases of Sphinx'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '0.1.1'

%w{ ubuntu debian }.each do |os|
  supports os
end

%w{ build-essential postgresql }.each do |cb|
  depends cb
end

recipe 'sphinx',               'Installs Sphinx 2.0.4-release'
recipe 'sphinx::all',          'Installs Sphinx 2.0.4-release, 1.10-beta and 0.9.9'
recipe 'sphinx::sphinx-2.0.4', 'Installs Sphinx 2.0.4-release'
recipe 'sphinx::sphinx-1.10',  'Installs Sphinx 1.10-beta'
recipe 'sphinx::sphinx-0.9.9', 'Installs Sphinx 0.9.9'
