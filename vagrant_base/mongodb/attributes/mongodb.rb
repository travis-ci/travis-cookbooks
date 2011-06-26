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
default[:mongodb][:auth]        = false
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

default[:mongodb][:replica_member_id] = 1
default[:mongodb][:replica_priority] = 1 # set to 0 if the node should never become master

default[:mongodb][:replica_initializer] = false # true if the node should initialize the set

### SHARDING
default[:mongodb][:shard_server]  = false



### BACKUP
default[:mongodb][:backup][:host]         = "localhost"
default[:mongodb][:backup][:backupdir]    = "/var/backups/mongodb"
default[:mongodb][:backup][:day]          = 6
default[:mongodb][:backup][:compression]  = "bzip2"
default[:mongodb][:backup][:cleanup]      = "yes"
default[:mongodb][:backup][:latest]       = "yes"
default[:mongodb][:backup][:mailaddress]  = false
default[:mongodb][:backup][:mailcontent]  = "stdout"
default[:mongodb][:backup][:maxemailsize] = 4000


### CONFIG SERVER
default[:mongodb][:config_server][:datadir]     = "/var/db/mongodb-config"
default[:mongodb][:config_server][:config]      = "/etc/mongodb-config.conf"
default[:mongodb][:config_server][:logfile]     = "/var/log/mongodb-config.log"
default[:mongodb][:config_server][:pidfile]     = "/var/run/mongodb-config.pid"
default[:mongodb][:config_server][:host]        = "localhost"
default[:mongodb][:config_server][:port]        = 27019



### MONGOS
default[:mongodb][:mongos][:config]      = "/etc/mongos.conf"
default[:mongodb][:mongos][:logfile]     = "/var/log/mongos.log"
default[:mongodb][:mongos][:pidfile]     = "/var/run/mongos.pid"
default[:mongodb][:mongos][:host]        = "localhost"
default[:mongodb][:mongos][:port]        = 27017


### Monit
default[:mongodb][:monit][:memory_usage]     = "60 %"
