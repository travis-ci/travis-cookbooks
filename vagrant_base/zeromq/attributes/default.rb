default[:zeromq][:package][:url]   = "http://files.travis-ci.org/packages/deb/zeromq/zeromq_2.1.10+fpm0_i386.deb"
default[:zeromq][:package][:user]  = node.travis_build_environment.user
default[:zeromq][:package][:group] = node.travis_build_environment.group
