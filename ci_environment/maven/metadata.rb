name             'maven'
maintainer       'Opscode, Inc.'
maintainer_email 'cookbooks@opscode.com'
license          'Apache 2.0'
description      'Installs maven 2 or 3 and includes a maven resource.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

depends 'ark',  '~> 0.4'
depends 'java', '~> 1.13'

supports 'centos'
supports 'debian'
supports 'fedora'
supports 'redhat'
supports 'ubuntu'
