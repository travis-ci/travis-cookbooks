# Set this to a branch name to copy down a binary directly from S3
default['travis']['worker']['branch'] = ''

# Disables writing a new config, as with hosts configured via cloud-init
default['travis']['worker']['disable_reconfiguration'] = false

# This should be the exact env vars
default['travis']['worker']['environment'] = {}

default['travis']['worker']['docker']['volume']['device'] = '/dev/xvdc'
default['travis']['worker']['docker']['volume']['metadata_size'] = '2G'
default['travis']['worker']['docker']['dm_basesize'] = '12G'
default['travis']['worker']['docker']['dm_fs'] = 'xfs'
default['travis']['worker']['docker']['dir'] = '/mnt/docker'

set['papertrail']['watch_files']['/var/log/upstart/travis-worker.log'] = 'travis-worker'

# rsyslogd must be root in order to read upstart logs :'(
set['rsyslog']['user'] = 'root'
set['rsyslog']['group'] = 'root'
set['rsyslog']['priv_seperation'] = false
