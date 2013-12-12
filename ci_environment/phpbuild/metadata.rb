# encoding: utf-8

name              "phpbuild"
maintainer        "Loïc Frering"
maintainer_email  "loic.frering@gmail.com"
license           "Apache 2.0"
description       "Installs php-build for compiling multiple PHP versions."
version           "1.0.0"

%w{ apt build-essential git networking_basic mysql postgresql libxml libssl }.each do |cb|
  depends cb
end
