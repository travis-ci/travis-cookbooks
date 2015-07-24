require 'fileutils'
FileUtils.touch("#{node['rsyslog']['config_prefix']}/rsyslog.d/server.conf")

include_recipe 'rsyslog::client'
