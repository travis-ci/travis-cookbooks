# Set this to a branch name to copy down a binary directly from S3
default['travis']['worker']['branch'] = ''
default['travis']['worker']['settings'] = {
  'PROVIDER_NAME' => 'bluebox'
}

set['papertrail']['watch_files']['/var/log/upstart/travis-worker.log'] = 'travis-worker'
