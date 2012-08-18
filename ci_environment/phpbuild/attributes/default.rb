default[:phpbuild][:git][:repository]                  = "git://github.com/CHH/php-build.git"
default[:phpbuild][:git][:revision]                    = "fdb4bad15410595dd09f83e241e3073052f21dec"
default[:phpbuild][:phpunit_plugin][:git][:repository] = "git://github.com/CHH/php-build-plugin-phpunit.git"
default[:phpbuild][:phpunit_plugin][:git][:revision]   = "a6a5ce4a5126b90a02dd473b63f660515de7d183"

default[:phpbuild][:custom][:php_ini][:memory_limit]  = "512M"
default[:phpbuild][:custom][:php_ini][:timezone]      = "UTC"

default[:phpbuild][:arch] = (kernel['machine'] =~ /x86_64/ ? "amd64" : "i386")
