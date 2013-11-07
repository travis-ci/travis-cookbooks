include_attribute "travis_build_environment::default"

default[:rvm][:version] = "latest-1.23"

case node[:platform]
when "debian", "ubuntu"
  default[:rvm][:pkg_requirements] = %w(gawk libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev)
  # This the list of packages returned by `rvm requirements' on Ubuntu 12.04.2
  # (of course it overlaps with cookbook dependencies, but it does not hurt to be listed here again)
else
  default[:rvm][:pkg_requirements] = []
end
