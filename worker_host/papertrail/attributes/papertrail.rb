
# Logger to use. Support loggers include: rsyslog.
default['papertrail']['logger'] = "rsyslog"

# Papertrail host to send stats to.
default['papertrail']['remote_host'] = "logs.papertrailapp.com"

# Port to use. MUST be set
# XXX: should pull from a databag since this is private
default['papertrail']['remote_port'] = nil

# Where to store papertrail cert file.
default['papertrail']['cert_file'] = "/etc/papertrail-bundle.pem"

# URL to download certificate from.
default['papertrail']['cert_url'] = "https://papertrailapp.com/tools/papertrail-bundle.pem"

# What CN should we accept from remote host?
# Note. Wildcard here is a hack to support logs2.papertrailapp.com's wildcard certificate
# Rsyslog doesn't support Wildcard certificates, but a wildcard matches '*.papertrailapp.com'
default['papertrail']['permitted_peer'] = "*.papertrailapp.com"

# By default, this recipe will log to Papertrail using the system's
# hostname. If you want to set the hostname that will be used (think
# ephemeral cloud nodes) you can set one of the following. If either is
# set it will use the hostname_name first and the hostname_cmd second.

# Set the logging hostname to this string.
default['papertrail']['hostname_name'] = ""

# Set the logging hostname to the output of this command passed to
# system(). This is useful if the desired hostname comes from a
# dynamic source like EC2 meta-data.
default['papertrail']['hostname_cmd'] = ""

# The number of times to retry the sending of failed messages (defaults to unlimited)
default['papertrail']['resume_retry_count'] = -1

# The maximum disk space allowed for queues (default to 100M)
default['papertrail']['queue_disk_space'] = '100M'

# The maximum number of events to queue (default to 100000)
default['papertrail']['queue_size'] = 100000

# The name of the disk queue (relative file name)
default['papertrail']['queue_file_name'] = 'papertrailqueue'

# File monitoring is not really a part of papertrail but is included here:
#
# default['papertrail']['watch_files'] - This is a list of files that will be
# configured to be watched and included in the papertrail logging. This
# is useful for including output from applications that aren't
# configured to use syslog. Each entry in this list is a hash of:
#
#            ['filename'] - Full path to the file.
#            ['tag'] - What to tag log lines that come from this file. Best to
#                     use a short application name.
#
# For example:
#
#   node['papertrail']['watch_files'] =
#              [{:filename => "/var/log/myapp.log", :tag => "myapp:"}]
#
default['papertrail']['watch_files'] = {}
