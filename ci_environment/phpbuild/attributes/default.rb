default[:phpbuild] = {
  :git => {
    :repository => "git://github.com/CHH/php-build.git",
    :revision   => "807ef1e1c79d2e010da58e50861ebd55b9bd1adb"
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
