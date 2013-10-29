default[:phpbuild] = {
  :git => {
    :repository => "git://github.com/CHH/php-build.git",
    :revision   => "99be44e6c45ee5edd147cea237cba3e4f1480f6c"
  },
  :phpunit_plugin => {
    :git => {
      :repository => "git://github.com/CHH/php-build-plugin-phpunit.git",
      :revision   => "2ee717c0e783809458f3073258c63f42500d1298"
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
