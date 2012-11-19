case platform
when 'mac_os_x'
  set['sbt-extras']['user_home_basedir']   = '/Users'
else # usual base directory on unix systems:
  set['sbt-extras']['user_home_basedir']   = '/home'
end

default['sbt-extras']['download_url']      = 'https://github.com/gildegoma/sbt-extras/raw/139803ca3880c20799bca030b33261c4509dc2d5/sbt'
# Refer to this fork, waiting for https://github.com/paulp/sbt-extras/pull/36 to be accepted and merged into master project.
default['sbt-extras']['default_sbt_version']   = '0.12.1' # ATTENTION: It must match with effective default sbt of installed script.
# Note: ideally, the default sbt version should be 'found' in downloaded script content (see issue #7)

default['sbt-extras']['setup_dir']         = '/opt/sbt-extras'
default['sbt-extras']['script_name']       = 'sbt'
default['sbt-extras']['owner']             = 'travis' 
default['sbt-extras']['group']             = 'sbt'      # group members are power users allowed to install sbt versions on demand
default['sbt-extras']['group_new_members'] = %w{ travis }
default['sbt-extras']['bin_symlink']       = '/usr/bin/sbt'

default['sbt-extras']['config_dir']        = '/etc/sbt'
#Template installation is disabled if filename is an empty string: 
default['sbt-extras']['sbtopts_filename']  = 'sbtopts'
default['sbt-extras']['jvmopts_filename']  = 'jvmopts'

# Following Parameters will be used during recipe execution and aslo used by /etc/sbt/sbtopts template
default['sbt-extras']['sbtopts']['mem']    = 1024 # in megabytes, Tuning of JVM -Xmx and -Xms 

default['sbt-extras']['preinstall_cmd']['timeout']  = 300 # A maximum of 5 minutes is allowed to download dependencies of a specific scala version.

# Optionally pre-install dependant libraries of requested sbt versions in user own environment
default['sbt-extras']['preinstall_matrix']['travis'] = %w{ 0.12.1 0.12.0 0.11.3 0.11.2 0.11.1 }
  # Known Problem: sbt 'boot' libraries are correclty installed since 0.11+ 
  # (see https://github.com/gildegoma/chef-sbt-extras/issues/5#issuecomment-10576361)
