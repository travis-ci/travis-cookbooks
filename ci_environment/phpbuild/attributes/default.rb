default['phpbuild']['git']['repository'] = 'git://github.com/php-build/php-build.git'
default['phpbuild']['git']['revision'] = 'edb42024864c7844523e3b5666e3088d116b5758'
default['phpbuild']['phpunit_plugin']['git']['repository'] = 'git://github.com/php-build/phpunit-plugin.git'
default['phpbuild']['phpunit_plugin']['git']['revision'] = 'f3edabe4498e4f2fbebdfa63d3ed7272eb129ba2'
default['phpbuild']['custom']['php_ini']['memory_limit'] = '1G'
default['phpbuild']['custom']['php_ini']['timezone'] = 'UTC'
default['phpbuild']['arch'] = (kernel['machine'] =~ /x86_64/ ? 'x86_64' : 'i386')
default['phpbuild']['prerequisite_recipes'] = %w(
  mysql::client
  postgresql::client
)
default['phpbuild']['packages'] = %w(
  lemon
  libbz2-dev
  libc-client2007e-dev
  libcurl4-gnutls-dev
  libexpat1-dev
  libfreetype6-dev
  libgmp3-dev
  libicu-dev
  libjpeg8-dev
  libkrb5-dev
  libldap2-dev
  libltdl-dev
  libmcrypt-dev
  libmhash-dev
  libpng12-dev
  libsasl2-dev
  libt1-dev
  libtidy-dev
  re2c
)
