default[:phpbuild] = {
  :git => {
    :repository => "git://github.com/php-build/php-build.git",
    :revision   => "5a48b6cfe9dddf7a21e7fc11cb8ba6dc85c2d686"
  },
  :phpunit_plugin => {
    :git => {
      :repository => "git://github.com/php-build/php-build-plugin-phpunit.git",
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
