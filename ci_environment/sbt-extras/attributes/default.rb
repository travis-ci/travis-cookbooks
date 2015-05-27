include_attribute 'travis_build_environment'

case platform
when 'mac_os_x'
  set['sbt-extras']['user_home_basedir']       = '/Users'
else # usual base directory on unix systems:
  set['sbt-extras']['user_home_basedir']       = '/home'
end

default['sbt-extras']['download_url']          = 'https://raw.githubusercontent.com/paulp/sbt-extras/c117e2a7f28fafacbb7cb56490ff7896e5dc7d8f/sbt'

default['sbt-extras']['setup_dir']             = '/usr/local/bin'
default['sbt-extras']['script_name']           = 'sbt'
default['sbt-extras']['owner']                 = 'root'
default['sbt-extras']['group']                 = node['travis_build_environment']['group']

default['sbt-extras']['config_dir']            = '/etc/sbt'


#
# Template installation is disabled if attribute below is nil or an empty string:
#

default['sbt-extras']['sbtopts']['filename']          = 'sbtopts'
default['sbt-extras']['sbtopts']['verbose']           = true      # in Travis CI: helpful to show how sbt-extras is working
default['sbt-extras']['sbtopts']['batch']             = true      # in Travis CI: never prompt!
default['sbt-extras']['sbtopts']['no-colors']         = false     # As for other languages, colored output looks nice in Travis CI Web UI, but
                                                                  # some users may prefer to disable colors for easier log parsing
                                                                  # (see for instance https://github.com/travis-ci/travis-ci/issues/1230)

default['sbt-extras']['jvmopts']['filename']          = 'jvmopts'
# in Travis CI: these attributes are not in use, since 'jvmopts' content is hard-tuned (but it might change...)
#default['sbt-extras']['jvmopts']['total_memory']      = 3072      # in megabytes, total memory available (used to define options like -Xmx, -Xms and so on)
#default['sbt-extras']['jvmopts']['thread_stack_size'] = 6         # in megabytes, used to defined -Xss option

default['sbt-extras']['system_wide_defaults']         = false     # if enabled, SBT_OPTS and JVM_OPTS will be exported via /etc/profile.d mechanism
                                                                  # in Travis CI: JVM_OPTS can conflict with other JVM software.
                                                                  #               These variables are thus managed by travis-build.
                                                                  #               (see travis-ci/travis-cookbooks#234)

#
# Pre-install scala/sbt base dependencies in user home (~/.sbt/boot/..., ~/.ivy2/cache/...)
#

# default['sbt-extras']['user_setup'][node['travis_build_environment']['user']]['sbt']   = %w{ 0.13.7 0.13.2 0.12.4 }
# default['sbt-extras']['user_setup'][node['travis_build_environment']['user']]['scala'] = %w{ 2.11.5 2.10.4 2.10.2 2.9.3 2.9.2 }

