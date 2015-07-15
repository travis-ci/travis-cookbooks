# Set this to a branch name to copy down a binary directly from S3
default['travis']['worker']['branch'] = ''

# This should be the exact env vars
default['travis']['worker']['environment'] = {}

set['papertrail']['watch_files']['/var/log/upstart/travis-worker.log'] = 'travis-worker'
