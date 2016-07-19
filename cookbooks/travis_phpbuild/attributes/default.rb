default['travis_phpbuild']['git']['repository'] = 'git://github.com/php-build/php-build.git'
default['travis_phpbuild']['git']['revision'] = '5a093b1774685d22ddd9a8965193d59873245117'
default['travis_phpbuild']['custom']['php_ini']['memory_limit'] = '1G'
default['travis_phpbuild']['custom']['php_ini']['timezone'] = 'UTC'
default['travis_phpbuild']['arch'] = (kernel['machine'] =~ /x86_64/ ? 'x86_64' : 'i386')
default['travis_phpbuild']['prerequisite_recipes'] = %w(
  postgresql::client
)
default['travis_phpbuild']['packages'] = %w(
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
