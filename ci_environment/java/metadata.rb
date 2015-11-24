name              "java"
maintainer        "Travis CI Team"
maintainer_email  "contact@travis-ci.org"
license           "Apache 2.0"
description       "Installs different Java Development Kits (JDK)"
version           "2.0.0"

supports 'ubuntu', '>= 12.04'

%w{ apt timezone }.each do |cb|
  depends cb
end

recipe "java::default", "Installs a default JDK"

# 'multi' is part of 'default' recipe, and should no *more* be included directly.
recipe "java::multi",   "Installs a alternative JDK versions"
