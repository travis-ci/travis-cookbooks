default['travis_php']['multi']['packages'] = %w(
  bison
  libbison-dev
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
  phpunit
  composer
)

default['travis_php']['multi']['versions'] = %w(
  5.4.45
  5.5.30
  5.6.15
)

default['travis_php']['multi']['aliases'] = {
  '5.4' => '5.4.45',
  '5.5' => '5.5.30',
  '5.6' => '5.6.15'
}

default['travis_php']['multi']['extensions'] = {
  'apc' => {
    'versions' => default['travis_php']['multi']['versions'].select { |version| version.start_with?('5.4') }
  },
  'memcached' => {
    'before_packages' => %w(libevent-dev libcloog-ppl1),
    'before_script'   => <<-EOF,
      wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
      tar xzf libmemcached-1.0.18.tar.gz
      cd libmemcached-1.0.18
      ./configure && make && make install
    EOF
    'script' => <<-EOF,
      pecl download memcached-2.2.0
      tar zxvf memcached*.tgz && cd memcached*
      make clean
      phpize
      ./configure --with-libmemcached-dir=/usr/local && make && make install
    EOF
    'versions' => default['travis_php']['multi']['versions']
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
    'versions' => default['travis_php']['multi']['versions'],
    'before_recipes'  => %w(zeromq::ppa),
    'before_packages' => %w(libzmq3-dev)
  },
  'redis' => {}
}
