require 'fileutils'
FileUtils.touch("#{node['rsyslog']['config_prefix']}/rsyslog.d/remote.conf")

include_recipe 'rsyslog::server'
