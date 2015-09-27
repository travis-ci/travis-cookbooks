name 'travis_java'
maintainer 'Travis CI Team'
maintainer_email 'contact+travis-cookbooks-travis-java@travis-ci.org'
license 'Apache 2.0'
description 'Installs different Java Development Kits (JDK)'
version '2.1.0'

supports 'ubuntu', '>= 12.04'

%w(apt travis_timezone).each do |cb|
  depends cb
end

recipe 'travis_java::default', 'Installs a default JDK'

# 'multi' is part of 'default' recipe, and should no *more* be included directly.
recipe 'travis_java::multi',   'Installs a alternative JDK versions'
