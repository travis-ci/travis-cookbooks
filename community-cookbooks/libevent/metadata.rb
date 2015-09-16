maintainer       "Takeshi KOMIYA"
maintainer_email "i.tkomiya@gmail.com"
license          "Apache 2.0"
description      "Installs libevent (from source)"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

%w{ fedora redhat centos ubuntu debian amazon }.each do |os|
  supports os
end

depends 'build-essential'
