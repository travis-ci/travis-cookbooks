
# Logger to use. Support loggers include: rsyslog.
default['papertrail']['logger'] = "rsyslog"

# Papertrail host to send stats to.
default['papertrail']['remote_host'] = "logs.papertrailapp.com"

# Port to use. MUST be set
# XXX: should pull from a databag since this is private
default['papertrail']['remote_port'] = nil

# Where to store papertrail cert file.
default['papertrail']['cert_file'] = "/etc/papertrail.crt"

# URL to download certificate from.
default['papertrail']['cert_url'] = "https://papertrailapp.com/tools/syslog.papertrail.crt"

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
