default[:php][:multi][:versions] = ["5.2.17", "5.3.3", "5.3.27", "5.4.21", "5.5.5"]
default[:php][:multi][:aliases]  = {"5.2" => "5.2.17", "5.3" => "5.3.27", "5.4" => "5.4.21", "5.5" => "5.5.5"}

default[:php][:multi][:extensions] = {
  'apc'       => {
    'versions' => default[:php][:multi][:versions].reject { |version| version.start_with?("5.5") }
  },
  'memcache'  => {},
  'memcached' => {
    'before_packages' => %w(libevent-dev libcloog-ppl0),
    'before_script'   => <<-EOF,
      wget https://launchpad.net/libmemcached/1.0/1.0.16/+download/libmemcached-1.0.16.tar.gz
      tar xzf libmemcached-1.0.16.tar.gz
      cd libmemcached-1.0.16
      ./configure && make && make install
    EOF
    'script'   => <<-EOF
      pecl download memcached
      tar zxvf memcached*.tgz && cd memcached*
      make clean
      phpize
      ./configure --with-libmemcached-dir=/usr/local && make && make install
    EOF
  },
  'mongo'     => {},
  'amqp'      => {
    'before_script' => <<-EOF
      git clone git://github.com/alanxz/rabbitmq-c.git
      cd rabbitmq-c
      git submodule init
      git submodule update
      autoreconf -i && ./configure && make && make install
    EOF
  },
  'pear.zero.mq/zmq-beta' => {
    'before_recipes'  => %w(zeromq::ppa),
    'before_packages' => %w(libzmq3-dev),
    'channel'         => 'pear.zero.mq'
  }
}
