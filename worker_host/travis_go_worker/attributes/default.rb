# Set this to a branch name to copy down a binary directly from S3
default['travis']['worker']['branch'] = ''

# This should be the exact env vars
default['travis']['worker']['environment'] = {}

set['papertrail']['watch_files']['/var/log/upstart/travis-worker.log'] = 'travis-worker'

# rsyslogd must be root in order to read upstart logs :'(
set['rsyslog']['user'] = 'root'
set['rsyslog']['group'] = 'root'
set['rsyslog']['priv_seperation'] = false
