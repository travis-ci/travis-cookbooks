maintainer       "Travis CI Development Team"
license          "Apache v2.0"
name             "travis_build_environment"
version          "1.0.0"
description      "Travis build environment"
long_description "Travis build environment"

depends "timezone"
depends "sysctl"
depends "openssh"
depends "unarchivers"
depends "iptables"

# Windows only
depends "chocolatey"

# Version control systems
depends "git"
depends "mercurial"
depends "subversion"

# Tools & libraries
depends "phantomjs"