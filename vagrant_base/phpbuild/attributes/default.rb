default[:phpbuild][:user]  = "vagrant"
default[:phpbuild][:group] = "vagrant"
default[:phpbuild][:home]  = "/home/vagrant"

default[:phpbuild][:git][:repository]                  = "git://github.com/CHH/php-build.git"
default[:phpbuild][:git][:revision]                    = "9164e0c325591916ad9185918e374facd2354d96"
default[:phpbuild][:phpunit_plugin][:git][:repository] = "git://github.com/CHH/php-build-plugin-phpunit.git"
default[:phpbuild][:phpunit_plugin][:git][:revision]   = "a6a5ce4a5126b90a02dd473b63f660515de7d183"

default[:phpbuild][:custom][:php_ini][:memory_limit]  = "512M"
default[:phpbuild][:custom][:php_ini][:timezone]      = "UTC"
