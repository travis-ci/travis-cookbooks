default['ark']['apache_mirror'] = 'http://apache.mirrors.tds.net'
default['ark']['prefix_root'] = '/usr/local'
default['ark']['prefix_bin'] = '/usr/local/bin'
default['ark']['prefix_home'] = '/usr/local'
default['ark']['tar'] = '/bin/tar'

pkgs = %w(libtool autoconf)
pkgs += %w(unzip rsync make gcc) unless platform_family?('mac_os_x')
pkgs += %w(autogen) unless platform_family?('rhel', 'fedora', 'mac_os_x')
pkgs += %w(gtar) if platform?('freebsd')

default['ark']['package_dependencies'] = pkgs
