name 'smf'
maintainer 'Eric Saxby'
maintainer_email 'sax@livinginthepast.org'
license 'MIT'
description 'A light weight resource provider (LWRP) for SMF (Service Management Facility)'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.2.7'

supports 'smartos'

depends 'rbac', '>= 1.0.1'

suggests 'resource-control' # For managing Solaris projects, when setting project on a manifest
