default[:phpbuild] = {
  :git => {
    :repository => "git://github.com/php-build/php-build.git",
    :revision   => "65ee5e3da7198496aa09a686784886dda43274d9"
  },
  :phpunit_plugin => {
    :git => {
      :repository => "git://github.com/php-build/phpunit-plugin.git",
      :revision   => "f3edabe4498e4f2fbebdfa63d3ed7272eb129ba2"
    }
  },
  :custom => {
    :php_ini => {
      :memory_limit => "1G",
      :timezone     => "UTC"
    }
  },
  :arch => (kernel['machine'] =~ /x86_64/ ? "x86_64" : "i386")
}
