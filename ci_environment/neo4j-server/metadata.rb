name              'neo4j-server'
maintainer        'Michael Klishin'
maintainer_email  'michael@defprotocol.org'
license           'MIT'
description       'This cookbook currently provides Neo4J Server 1.9+ (Community Edition) but can be used to install other versions by overriding data bag attributes.'
version           '1.0.0'
depends           'java', '>= 0.0.1'

recipe 'neo4j-server::tarball', 'Installs a Neo4j server'

%w{ ubuntu debian redhat centos scientific amazon oracle }.each do |os|
  supports os
end
