default[:phpfarm][:user]  = "vagrant"
default[:phpfarm][:group] = "vagrant"
default[:phpfarm][:home]  = "/home/vagrant"

default[:phpfarm][:custom][:php_ini][:memory_limit]  = "512M"
default[:phpfarm][:custom][:php_ini][:timezone]      = "UTC"
