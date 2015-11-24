### SOURCE PACKAGES
default[:mongodb][:version]           = "1.6.5"
default[:mongodb][:source]            = "http://fastdl.mongodb.org/linux/mongodb-linux-#{node[:kernel][:machine]}-#{mongodb[:version]}.tgz"
default[:mongodb][:i686][:checksum]   = "e64d9f4ce31d789caef7370b863cf59d"
default[:mongodb][:x86_64][:checksum] = "14f89864f3b58fc20f22ec0068325870"

### GENERAL
default[:mongodb][:dir]         = "/opt/mongodb-#{mongodb[:version]}" # For install from source
default[:mongodb][:datadir]     = "/var/db/mongodb"
default[:mongodb][:config]      = "/etc/mongodb.conf"
default[:mongodb][:logfile]     = "/var/log/mongodb.log"
default[:mongodb][:pidfile]     = "/var/run/mongodb.pid"
default[:mongodb][:port]        = 27017

default[:mongodb][:bind_ip] = '127.0.0.1'


### EXTRA
default[:mongodb][:log_cpu_io]  = false
default[:mongodb][:auth]        = true
default[:mongodb][:username]    = ""
default[:mongodb][:password]    = ""
default[:mongodb][:verbose]     = false
default[:mongodb][:objcheck]    = false
default[:mongodb][:quota]       = false
default[:mongodb][:diaglog]     = false
default[:mongodb][:nocursors]   = false
default[:mongodb][:nohints]     = false
default[:mongodb][:nohttp]      = false
default[:mongodb][:noscripting] = false
default[:mongodb][:notablescan] = false
default[:mongodb][:noprealloc]  = false
default[:mongodb][:nssize]      = false



### STARTUP
default[:mongodb][:rest]        = false
default[:mongodb][:syncdelay]   = 60

default[:mongodb][:service][:enabled] = false

### MMS
default[:mongodb][:mms]       = false
default[:mongodb][:token]     = ""
default[:mongodb][:name]      = ""
default[:mongodb][:interval]  = ""



### REPLICATION
default[:mongodb][:replication]   = false

default[:mongodb][:autoresync]    = false
default[:mongodb][:oplogsize]     = 0
default[:mongodb][:opidmem]       = 0

default[:mongodb][:replica_set]   = "none"


### CONFIG SERVER
default[:mongodb][:config_server][:datadir]     = "/var/lib/mongodb"
default[:mongodb][:config_server][:config]      = "/etc/mongodb-config.conf"
default[:mongodb][:config_server][:logfile]     = "/var/log/mongodb-config.log"
default[:mongodb][:config_server][:pidfile]     = "/var/run/mongodb-config.pid"
default[:mongodb][:config_server][:host]        = "localhost"
default[:mongodb][:config_server][:port]        = 27019
