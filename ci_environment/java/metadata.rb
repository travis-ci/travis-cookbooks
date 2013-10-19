name              "java"
maintainer        "Travis CI Team"
maintainer_email  "contact@travis-ci.org"
license           "Apache 2.0"
description       "Installs different Java Development Kits (JDK)"
version           "2.0"

supports 'ubuntu', '>= 12.04'

%w{ apt timezone }.each do |cb|
  depends cb
end

#TODO recipe list will be described when refactoring is finished:
#recipe "java", "Installs Java runtime"
#recipe "java::openjdk", "Installs the OpenJDK flavor of Java"
#recipe "java::sun", "Installs the Sun flavor of Java"
