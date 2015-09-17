default[:phpbuild] = {
  :git => {
    :repository => "git://github.com/CHH/php-build.git",
    :revision   => "0df4c0c044669e13ae3bd8cee7a49ce33b49dc1f"
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
