name             'opsmatic'
maintainer       'Marcus Barczak'
maintainer_email 'support@opsmatic.com'
license          'All rights reserved'
description      'Installs/Configures Opsmatic services and integrations'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.14'

depends 'chef_handler'
depends 'apt'
