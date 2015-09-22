name 'libevent'
# maintainer 'Takeshi KOMIYA'
# maintainer_email 'i.tkomiya@gmail.com'
maintainer 'Travis CI GmbH'
maintainer_email 'contact+travis-cookbooks-libevent@travis-ci.org'
license 'Apache 2.0'
description 'Installs libevent (from source)'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.2.0'

%w(fedora redhat centos ubuntu debian amazon).each do |os|
  supports os
end

depends 'build-essential'
