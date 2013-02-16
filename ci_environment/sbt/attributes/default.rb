include_attribute 'travis_build_environment'

case platform
when 'mac_os_x'
  set['sbt-extras']['user_home_basedir']    = '/Users'
else # usual base directory on unix systems:
  set['sbt-extras']['user_home_basedir']    = '/home'
end
override['sbt-extras']['user_home_basedir'] = node['travis_build_environment']['home'].split("/#{node['travis_build_environment']['user']}").first

default['sbt-extras']['download_url']      = 'https://raw.github.com/gildegoma/sbt-extras/travis-ci/sbt'
# Refer to this forked 'travis-ci' branch, waiting for https://github.com/paulp/sbt-extras/pull/36 to be accepted and merged into master project.
default['sbt-extras']['default_sbt_version']   = '0.12.2' # ATTENTION: It must match with effective default sbt of installed script.
# Note: ideally, the default sbt version should be 'found' in downloaded script content (see issue #7)

default['sbt-extras']['setup_dir']         = '/opt/sbt-extras'
default['sbt-extras']['script_name']       = 'sbt'
default['sbt-extras']['owner']             = node['travis_build_environment']['user']
default['sbt-extras']['group']             = node['travis_build_environment']['group']
default['sbt-extras']['group_new_members'] = []
default['sbt-extras']['bin_symlink']       = '/usr/bin/sbt'

default['sbt-extras']['config_dir']        = '/etc/sbt'
#Template installation is disabled if filename is an empty string:
default['sbt-extras']['sbtopts_filename']  = 'sbtopts'
default['sbt-extras']['jvmopts_filename']  = 'jvmopts'

# Following Parameters will be used during recipe execution and also when installing /etc/sbt/sbtopts template
default['sbt-extras']['sbtopts']['mem']    = 1024 # in megabytes, Tuning of JVM -Xmx and -Xms

default['sbt-extras']['preinstall_cmd']['timeout']  = 300 # A maximum of 5 minutes is allowed to download dependencies of a specific scala version.

# Optionally pre-install dependant libraries of requested sbt versions in user own environment
default['sbt-extras']['preinstall_matrix'][node['travis_build_environment']['user']] = %w{ 0.12.2 0.12.1 0.12.0 0.11.3 0.11.2 0.11.1 }
  # Known Problem: sbt 'boot' libraries are correclty installed since 0.11+
  # (see https://github.com/gildegoma/chef-sbt-extras/issues/5#issuecomment-10576361)
