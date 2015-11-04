default['travis_php']['multi']['packages'] = %w(
  autoconf
  bison
  build-essential
  libbison-dev
  libfreetype6-dev
  libreadline6-dev
)
default['travis_php']['multi']['prerequisite_recipes'] = %w(
  travis_phpenv
  travis_phpbuild
)
default['travis_php']['multi']['postrequisite_recipes'] = %w(
  travis_php::extensions
  travis_php::hhvm
  travis_php::hhvm-nightly
  travis_php::phpunit
  travis_php::composer
)
multi_versions = %w(
  5.4.45
  5.5.30
  5.6.15
)
default['travis_php']['multi']['versions'] = multi_versions
default['travis_php']['multi']['aliases'] = {
  '5.4' => '5.4.45',
  '5.5' => '5.5.30',
  '5.6' => '5.6.15'
}
default['travis_php']['multi']['extensions']['amqp']['before_script'] = <<-EOF
  git clone git://github.com/alanxz/rabbitmq-c.git
  cd rabbitmq-c
  git checkout tags/v0.5.2
  git submodule init
  git submodule update
  autoreconf -i && ./configure && make && make install
EOF
default['travis_php']['multi']['extensions']['apc']['versions'] = multi_versions.select { |v| v =~ /^5\.4/ }
default['travis_php']['multi']['extensions']['memcached']['before_packages'] = %w(libevent-dev libcloog-ppl1)
default['travis_php']['multi']['extensions']['memcached']['before_script'] = <<-EOF
  wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
  tar xzf libmemcached-1.0.18.tar.gz
  cd libmemcached-1.0.18
  ./configure && make && make install
EOF
default['travis_php']['multi']['extensions']['memcached']['script'] = <<-EOF
  pecl download memcached-2.2.0
  tar zxvf memcached*.tgz && cd memcached*
  make clean
  phpize
  ./configure --with-libmemcached-dir=/usr/local && make && make install
EOF
default['travis_php']['multi']['extensions']['memcached']['versions'] = multi_versions
default['travis_php']['multi']['extensions']['mongo'] = {}
default['travis_php']['multi']['extensions']['redis'] = {}
default['travis_php']['multi']['extensions']['zmq-beta']['versions'] = multi_versions
default['travis_php']['multi']['extensions']['zmq-beta']['before_recipes'] = %w(zeromq::ppa)
default['travis_php']['multi']['extensions']['zmq-beta']['before_packages'] = %w(libzmq3-dev)

default['travis_php']['hhvm']['package']['name'] = 'hhvm'
default['travis_php']['hhvm']['package']['version'] = '3.10.1~trusty'

default['travis_php']['composer']['github_oauth_token'] = nil
