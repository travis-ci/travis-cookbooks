maintainer        "Michael Strüder"
maintainer_email  "mikezter@gmail.com"
license           "Apache 2.0"
description       "Installs and configures MongoDB 1.8.1"
version           "0.3"

recipe "mongodb::apt", "Installs MongoDB from 10Gen's apt source and includes init.d script"
recipe "mongodb::source", "Installs MongoDB from source and includes init.d script"
recipe "mongodb::backup", "Sets up MongoDB backup script, taken from http://github.com/micahwedemeyer/automongobackup"

%w{ ubuntu debian }.each do |os|
  supports os
end

# Package info
attribute "mongodb/version",
  :display_name => "MongoDB version",
  :description => "Which MongoDB version will be installed",
  :default => "1.8.1"

attribute "mongodb/source",
  :display_name => "MongoDB source file",
  :description => "Downloaded location for MongoDB"

attribute "mongodb/checksum",
  :display_name => "MongoDB source file checksum",
  :description => "Will make sure the source file is the real deal",
  :default => "e75a5cae641a53760df8cb866ad5d929"


# Paths & port
attribute "mongodb/dir",
  :display_name => "MongoDB installation path",
  :description => "MongoDB will be installed here",
  :default => "/opt/mongodb"

attribute "mongodb/datadir",
  :display_name => "MongoDB data store",
  :description => "All MongoDB data will be stored here",
  :default => "/var/lib/mongodb"

attribute "mongodb/config",
  :display_name => "MongoDB config",
  :description => "Path to MongoDB config file",
  :default => "/etc/mongodb.conf"

attribute "mongodb/logfile",
  :display_name => "MongoDB log file",
  :description => "MongoDB will log into this file",
  :default => "/var/log/mongodb/mongodb.log"

attribute "mongodb/pidfile",
  :display_name => "MongoDB PID file",
  :description => "Path to MongoDB PID file",
  :default => "/var/run/mongodb.pid"

attribute "mongodb/port",
  :display_name => "MongoDB port",
  :description => "Accept connections on the specified port",
  :default => "27017"

# Logging, access & others
attribute "mongodb/log_cpu_io",
  :display_name => "MongoDB CPU & I/O logging",
  :description => "Enables periodic logging of CPU utilization and I/O wait",
  :default => "false"

attribute "mongodb/auth",
  :display_name => "MongoDB authentication",
  :description => "Turn on/off security",
  :default => "false"

attribute "mongodb/username",
  :display_name => "MongoDB useranme",
  :description => "If authentication is on, you might want to specify this for the db backups"

attribute "mongodb/password",
  :display_name => "MongoDB password",
  :description => "If authentication is on, you might want to specify this for the db backups"

attribute "mongodb/verbose",
  :display_name => "MongoDB verbose",
  :description => "Verbose logging output",
  :default => "false"

attribute "mongodb/objcheck",
  :display_name => "MongoDB objcheck",
  :description => "Inspect all client data for validity on receipt (useful for developing drivers)",
  :default => "false"

attribute "mongodb/quota",
  :display_name => "MongoDB quota",
  :description => "Enable db quota management",
  :default => "false"

attribute "mongodb/diaglog",
  :display_name => "MongoDB operations loggins",
  :description => "Set oplogging level where n is 0=off (default) 1=W 2=R 3=both 7=W+some reads",
  :default => "false"

attribute "mongodb/nocursors",
  :display_name => "MongoDB nocursors",
  :description => "Diagnostic/debugging option",
  :default => "false"

attribute "mongodb/nohints",
  :display_name => "MongoDB nohints",
  :description => "Ignore query hints",
  :default => "false"

attribute "mongodb/nohttp",
  :display_name => "MongoDB nohttp",
  :description => "Disable the HTTP interface (Defaults to localhost:27018)",
  :default => "false"

attribute "mongodb/noscripting",
  :display_name => "MongoDB noscripting",
  :description => "Turns off server-side scripting. This will result in greatly limited functionality.",
  :default => "false"

attribute "mongodb/notablescan",
  :display_name => "MongoDB notablescan",
  :description => "Turns off table scans. Any query that would do a table scan fails.",
  :default => "false"

attribute "mongodb/noprealloc",
  :display_name => "MongoDB noprealloc",
  :description => "Disable data file preallocation",
  :default => "false"

attribute "mongodb/nssize",
  :display_name => "MongoDB nssize",
  :description => "Specify .ns file size for new databases",
  :default => "false"

# Daemon options
attribute "mongodb/rest",
  :display_name => "MongoDB REST",
  :description => "Enables REST interface for extra info on Http Interface",
  :default => "false"

attribute "mongodb/syncdelay",
  :display_name => "MongoDB syncdelay",
  :description => "Controls how often changes are flushed to disk",
  :default => "60"

# Monitoring
attribute "mongodb/mms",
  :display_name => "MongoDB mms",
  :description => "Enable when you have a Mongo monitoring server",
  :default => "false"

attribute "mongodb/token",
  :display_name => "MongoDB mms-token",
  :description => "Accout token for Mongo monitoring server"

attribute "mongodb/name",
  :display_name => "MongoDB mms-name",
  :description => "Server name for Mongo monitoring server"

attribute "mongodb/interval",
  :display_name => "MongoDB mms-interval",
  :description => "Ping interval for Mongo monitoring server"

# Replication
attribute "mongodb/replication",
  :display_name => "MongoDB replication",
  :description => "Enable if you want to configure replication",
  :default => "false"

attribute "mongodb/arbiter",
  :display_name => "MongoDB replication arbiter",
  :description => "Address of arbiter server"

attribute "mongodb/autoresync",
  :display_name => "MongoDB replication autoresync",
  :description => "Automatically resync if slave data is stale",
  :default => "false"

attribute "mongodb/oplogsize",
  :display_name => "MongoDB replication oplogsize",
  :description => "Custom size for replication operation log (in MB)",
  :default => "0"

attribute "mongodb/opidmem",
  :display_name => "MongoDB replication opidmem",
  :description => "Custom size limit for in-memory storage of op ids (in MB)",
  :default => "0"

# Backups
attribute "mongodb/backup/backupdir",
  :display_name => "MongoDB backup directory",
  :description => "Backup directory location",
  :default => "/var/backups/mongodb"

attribute "mongodb/backup/day",
  :display_name => "MongoDB backup day",
  :description => "Which day do you want weekly backups? (1 to 7 where 1 is Monday)",
  :default => "6"

attribute "mongodb/backup/compression",
  :display_name => "MongoDB backup compression",
  :description => "Choose Compression type. (gzip or bzip2)",
  :default => "bzip2"

attribute "mongodb/backup/cleanup",
  :display_name => "MongoDB backup cleanup",
  :description => "Choose if the uncompressed folder should be deleted after compression has completed",
  :default => "yes"

attribute "mongodb/backup/latest",
  :display_name => "MongoDB backup latest",
  :description => "Additionally keep a copy of the most recent backup in a seperate directory",
  :default => "yes"

attribute "mongodb/backup/mailaddress",
  :display_name => "MongoDB backup mail",
  :description => "Email Address to send mail to after each backup",
  :default => "false"

attribute "mongodb/backup/mailcontent",
  :display_name => "MongoDB backup mailcontent",
  :description => %{
    What would you like to be mailed to you?
    - log   : send only log file
    - files : send log file and sql files as attachments (see docs)
    - stdout : will simply output the log to the screen if run manually
    - quiet : Only send logs if an error occurs
  }.strip,
  :default => "stdout"

attribute "mongodb/backup/maxemailsize",
  :display_name => "MongoDB backup max email size",
  :description => "Set the maximum allowed email size in k. (4000 = approx 5MB email)",
  :default => "4000"
