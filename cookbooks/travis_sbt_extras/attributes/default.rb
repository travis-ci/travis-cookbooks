# frozen_string_literal: true

include_attribute 'travis_build_environment'

default['travis_sbt_extras']['user_home_basedir'] = '/home'

default['travis_sbt_extras']['download_url'] = 'https://raw.githubusercontent.com/paulp/sbt-extras/6ae480fa7989a0f58ce284bc769a7deeb1f27a21/sbt'

default['travis_sbt_extras']['setup_dir'] = '/usr/local/bin'
default['travis_sbt_extras']['script_name'] = 'sbt'
default['travis_sbt_extras']['owner'] = 'root'
default['travis_sbt_extras']['group'] = node['travis_build_environment']['group']

default['travis_sbt_extras']['config_dir'] = '/etc/sbt'

#
# Template installation is disabled if attribute below is nil or an empty string:
#

default['travis_sbt_extras']['sbtopts']['filename'] = 'sbtopts'
default['travis_sbt_extras']['sbtopts']['verbose'] = true # in Travis CI: helpful to show how sbt-extras is working
default['travis_sbt_extras']['sbtopts']['batch'] = true # in Travis CI: never prompt!
default['travis_sbt_extras']['sbtopts']['no-colors'] = false # As for other languages, colored output looks nice in Travis CI Web UI, but
# some users may prefer to disable colors for easier log parsing
# (see for instance https://github.com/travis-ci/travis-ci/issues/1230)

default['travis_sbt_extras']['jvmopts']['filename'] = 'jvmopts'
# in Travis CI: these attributes are not in use, since 'jvmopts' content is hard-tuned (but it might change...)
# default['travis_sbt_extras']['jvmopts']['total_memory'] = 3072      # in megabytes, total memory available (used to define options like -Xmx, -Xms and so on)
# default['travis_sbt_extras']['jvmopts']['thread_stack_size'] = 6         # in megabytes, used to defined -Xss option

default['travis_sbt_extras']['system_wide_defaults'] = false # if enabled, SBT_OPTS and JVM_OPTS will be exported via /etc/profile.d mechanism
# in Travis CI: JVM_OPTS can conflict with other JVM software.
#               These variables are thus managed by travis-build.
#               (see travis-ci/travis-cookbooks#234)

#
# Pre-install scala/sbt base dependencies in user home (~/.sbt/boot/..., ~/.ivy2/cache/...)
#

# default['travis_sbt_extras']['user_setup'][node['travis_build_environment']['user']]['sbt']   = %w{ 0.13.7 0.13.2 0.12.4 }
# default['travis_sbt_extras']['user_setup'][node['travis_build_environment']['user']]['scala'] = %w{ 2.11.5 2.10.4 2.10.2 2.9.3 2.9.2 }
