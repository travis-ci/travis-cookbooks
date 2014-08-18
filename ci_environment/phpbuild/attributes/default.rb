default[:phpbuild] = {
  :git => {
    :repository => "git://github.com/CHH/php-build.git",
    :revision   => "1cbd438e11e402cb7a2554ca1db76c4514545cba"
  },
  :phpunit_plugin => {
    :git => {
      :repository => "git://github.com/CHH/php-build-plugin-phpunit.git",
      :revision   => "2ee717c0e783809458f3073258c63f42500d1298"
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
