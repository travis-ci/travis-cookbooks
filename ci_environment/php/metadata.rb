# encoding: utf-8

name              "php"
maintainer        "Loïc Frering"
maintainer_email  "loic.frering@gmail.com"
license           "Apache 2.0"
description       "Installs php-build and phpenv for multiple PHP versions management."
version           "1.0.0"

depends "apt"
depends "build-essential"

depends "bison"           # required to ensure that bison version is compatible with annoying php whitelist
                          # (This trick is required up to PHP 5.5.3, see https://github.com/php/php-src/pull/402)
depends "libreadline"     # required to build PHP from C/C++ source

depends "composer"
depends "phpbuild"
depends "phpenv"

depends "hhvm"
