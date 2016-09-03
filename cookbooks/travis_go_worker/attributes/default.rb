# Set this to a branch name to copy down a binary directly from S3
default['travis_go_worker']['branch'] = ''

# Disables writing a new config, as with hosts configured via cloud-init
default['travis_go_worker']['disable_reconfiguration'] = false

# The members under `environment` should be the exact env vars
default['travis_go_worker']['environment']['TRAVIS_WORKER_WARMED_DOCKER_IMAGES'] = ''
default['travis_go_worker']['environment']['TRAVIS_WORKER_SELF_IMAGE'] = 'quay.io/travisci/worker:v2.3.1-61-g76a687b'
default['travis_go_worker']['environment']['TRAVIS_WORKER_DISABLE_DIRECT_LVM'] = ''

default['travis_go_worker']['docker']['disable_install'] = false
default['travis_go_worker']['docker']['disable_direct_lvm'] = false
default['travis_go_worker']['docker']['volume']['device'] = '/dev/xvdc'
default['travis_go_worker']['docker']['volume']['metadata_size'] = '2G'
default['travis_go_worker']['docker']['dm_basesize'] = '12G'
default['travis_go_worker']['docker']['dm_fs'] = 'xfs'
default['travis_go_worker']['docker']['dir'] = '/mnt/docker'

set['papertrail']['watch_files']['/var/log/upstart/travis-worker.log'] = 'travis-worker'

# rsyslogd must be root in order to read upstart logs :'(
set['rsyslog']['user'] = 'root'
set['rsyslog']['group'] = 'root'
set['rsyslog']['priv_seperation'] = false
