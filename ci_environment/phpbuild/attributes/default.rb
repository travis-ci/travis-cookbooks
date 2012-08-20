default[:phpbuild] = {
  :git => {
    :repository => "git://github.com/CHH/php-build.git",
    :revision   => "fdb4bad15410595dd09f83e241e3073052f21dec"
  },
  :phpunit_plugin => {
    :git => {
      :repository => "git://github.com/CHH/php-build-plugin-phpunit.git",
      :revision   => "a6a5ce4a5126b90a02dd473b63f660515de7d183"
    }
  },
  :custom => {
    :php_ini => {
      :memory_limit => "512M",
      :timezone     => "UTC"
    }
  },
  :arch => (kernel['machine'] =~ /x86_64/ ? "x86_64" : "i386")
}
