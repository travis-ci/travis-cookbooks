#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: php
# Attribute:: default
#
# Copyright 2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

lib_dir = kernel['machine'] =~ /x86_64/ ? 'lib64' : 'lib'

default['php']['install_method'] = 'package'

case node["platform"]
when "centos", "redhat", "fedora"
  default['php']['conf_dir']      = '/etc'
  default['php']['ext_conf_dir']  = '/etc/php.d'
  default['php']['fpm_user']      = 'nobody'
  default['php']['fpm_group']     = 'nobody'
  default['php']['ext_dir']       = "/usr/#{lib_dir}/php/modules"
when "debian", "ubuntu"
  default['php']['conf_dir']      = '/etc/php5/cli'
  default['php']['ext_conf_dir']  = '/etc/php5/conf.d'
  default['php']['fpm_user']      = 'www-data'
  default['php']['fpm_group']     = 'www-data'
else
  default['php']['conf_dir']      = '/etc/php5/cli'
  default['php']['ext_conf_dir']  = '/etc/php5/conf.d'
  default['php']['fpm_user']      = 'www-data'
  default['php']['fpm_group']     = 'www-data'
end

default['php']['url'] = 'http://us.php.net/distributions'
default['php']['version'] = '5.3.5'
default['php']['checksum'] = 'a25ddae6a59d7345bcbb69ef2517784f56c2069af663ae4611e580cbdec77e22'
default['php']['prefix_dir'] = '/usr/local'
default['php']['multi']['versions'] = %w(
  5.4.45
  5.5.29
  5.6.13
)

default['php']['multi']['aliases'] = {
  '5.4' => '5.4.45',
  '5.5' => '5.5.29',
  '5.6' => '5.6.13'
}

default['php']['multi']['extensions'] = {
  'apc'       => {
    'versions' => default['php']['multi']['versions'].select { |version| version.start_with?('5.4') }
  },
  'memcached' => {
    'before_packages' => %w(libevent-dev libcloog-ppl1),
    'before_script'   => <<-EOF,
      wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
      tar xzf libmemcached-1.0.18.tar.gz
      cd libmemcached-1.0.18
      ./configure && make && make install
    EOF
    'script'   => <<-EOF,
      pecl download memcached-2.2.0
      tar zxvf memcached*.tgz && cd memcached*
      make clean
      phpize
      ./configure --with-libmemcached-dir=/usr/local && make && make install
    EOF
    'versions' => default['php']['multi']['versions']
  },
  'mongo'     => {},
  'amqp'      => {
    'before_script' => <<-EOF
      git clone git://github.com/alanxz/rabbitmq-c.git
      cd rabbitmq-c
      git checkout tags/v0.5.2
      git submodule init
      git submodule update
      autoreconf -i && ./configure && make && make install
    EOF
  },
  'zmq-beta' => {
    'versions' => default['php']['multi']['versions'],
    'before_recipes'  => %w(zeromq::ppa),
    'before_packages' => %w(libzmq3-dev)
  },
  'redis' => {}
}

if node['lsb']['codename'] == 'precise'
  default['php']['multi']['versions'] = %w(
    5.3.29
    5.4.45
    5.5.9
    5.5.29
    5.6.13
  )
  default['php']['multi']['aliases'] = {
    '5.3' => '5.3.29',
    '5.4' => '5.4.45',
    '5.5' => '5.5.29',
    '5.6' => '5.6.13'
  }
end

default['php']['configure_options'] = %W{--prefix=#{php['prefix_dir']}
                                          --with-libdir=#{lib_dir}
                                          --with-config-file-path=#{php['conf_dir']}
                                          --with-config-file-scan-dir=#{php['ext_conf_dir']}
                                          --with-pear
                                          --enable-fpm
                                          --with-fpm-user=#{php['fpm_user']}
                                          --with-fpm-group=#{php['fpm_group']}
                                          --with-zlib
                                          --with-openssl
                                          --with-kerberos
                                          --with-bz2
                                          --with-curl
                                          --enable-ftp
                                          --enable-zip
                                          --enable-exif
                                          --with-gd
                                          --enable-gd-native-ttf
                                          --with-gettext
                                          --with-gmp
                                          --with-mhash
                                          --with-iconv
                                          --with-imap
                                          --with-imap-ssl
                                          --enable-sockets
                                          --enable-soap
                                          --with-xmlrpc
                                          --with-libevent-dir
                                          --with-mcrypt
                                          --enable-mbstring
                                          --with-t1lib
                                          --with-mysql
                                          --with-mysqli=/usr/bin/mysql_config
                                          --with-mysql-sock
                                          --with-sqlite3
                                          --with-pdo-mysql
                                          --with-pdo-sqlite}
