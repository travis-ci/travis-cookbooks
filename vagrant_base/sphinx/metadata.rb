maintainer        'Pat Allan'
maintainer_email  'pat@freelancing-gods.com'
license           'MIT'
description       'Installs stable and beta releases of Sphinx'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '0.1.0'
depends           'build-essential'

recipe 'sphinx',               'Installs and configures Sphinx 2.0.1-beta'
recipe 'sphinx::sphinx-1.10',  'Installs and configures Sphinx 1.10-beta'
recipe 'sphinx::sphinx-0.9.9', 'Installs and configures Sphinx 0.9.9'

%w{ ubuntu debian }.each do |os|
  supports os
end
