default[:firefox][:version]      = "19.0"
default[:firefox][:download_url] = "http://ftp.mozilla.org/pub/firefox/releases/#{node['firefox']['version']}/linux-#{kernel['machine']}/en-US/firefox-#{node['firefox']['version']}.tar.bz2"
