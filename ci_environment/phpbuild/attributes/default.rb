default[:phpbuild][:git][:repository]                      = "git://github.com/CHH/php-build.git"
default[:phpbuild][:git][:revision]                        = "893a8a113e73b16f69fa3b2d74b92c249810aca2"
default[:phpbuild][:plugins][:phpunit][:git][:repository]  = "git://github.com/CHH/php-build-plugin-phpunit.git"
default[:phpbuild][:plugins][:phpunit][:git][:revision]    = "a6a5ce4a5126b90a02dd473b63f660515de7d183"
default[:phpbuild][:plugins][:phpunit][:php_versions]      = ["5.2", "5.3", "5.4"]
default[:phpbuild][:plugins][:composer][:git][:repository] = "git://github.com/stloyd/php-build-plugin-composer.git"
default[:phpbuild][:plugins][:composer][:git][:revision]   = "8bc5a0100a67908f10875e0bf1a9c10796271362"
default[:phpbuild][:plugins][:composer][:php_versions]     = ["5.3", "5.4"]

default[:phpbuild][:custom][:php_ini][:memory_limit]       = "512M"
default[:phpbuild][:custom][:php_ini][:timezone]           = "UTC"
