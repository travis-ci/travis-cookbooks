name             "kerl"
maintainer       "Michael S. Klishin"
maintainer_email "michael.s.klishin@gmail.com"
license          "Apache 2.0"
description      "Installs kerl for managing Erlang versions."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

depends 'libncurses'
depends 'libreadline'
depends 'libssl'
depends 'travis_build_environment'
