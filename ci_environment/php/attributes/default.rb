default[:php][:multi][:versions] = ["5.2.17", "5.3.3", "5.3.22", "5.4.12", "5.5.0alpha4"]
default[:php][:multi][:aliases]  = {"5.2" => "5.2.17", "5.3" => "5.3.22", "5.4" => "5.4.12", "5.5" => "5.5.0alpha4"}

default[:php][:multi][:extensions] = {
  'apc'       => {},
  'memcache'  => {},
  'memcached' => {
    'before_packages' => %w(libevent-dev libcloog-ppl0),
    'before_script'   => <<-EOF
      wget https://launchpad.net/libmemcached/1.0/1.0.13/+download/libmemcached-1.0.13.tar.gz
      tar xzf libmemcached-1.0.13.tar.gz
      cd libmemcached-1.0.13
      ./configure && make && make install
    EOF
  },
  'mongo'     => {},
  'amqp'      => {
    'before_script'   => <<-EOF
      git clone git://github.com/alanxz/rabbitmq-c.git
      cd rabbitmq-c
      git submodule init
      git submodule update
      autoreconf -i && ./configure && make && make install
    EOF
  },
  'pear.zero.mq/zmq-beta' => {
    'channel'         => 'pear.zero.mq',
    'before_packages' => %w(libzmq-dev)
  }
}
