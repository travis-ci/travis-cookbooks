name 'lein'
maintainer 'Michael S. Klishin'
maintainer_email 'michael@clojurewerkz.org'
license 'Apache 2.0'
description 'Installs/configures Leiningen 2.x'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.0'
depends 'java'

%w(ubuntu centos redhat fedora amazon).each do |os|
  supports os
end
