default[:phpbuild] = {
  :git => {
    :repository => "git://github.com/CHH/php-build.git",
    :revision   => "edb42024864c7844523e3b5666e3088d116b5758"
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
