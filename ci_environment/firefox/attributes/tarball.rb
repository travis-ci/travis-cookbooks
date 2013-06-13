default['firefox']['tarball']['version']              = "19.0"
default['firefox']['tarball']['download_url']         = "http://ftp.mozilla.org/pub/firefox/releases/#{node['firefox']['tarball']['version']}/linux-#{kernel['machine']}/en-US/firefox-#{node['firefox']['tarball']['version']}.tar.bz2"

# Required distro packages, preconfigured for Ubuntu 12.04
default['firefox']['tarball']['package_dependencies'] = %w(libasound2 libatk1.0-0 libc6 libcairo2 libdbus-1-3 libdbus-glib-1-2 libfontconfig1 libfreetype6 libgcc1 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk2.0-0 libnotify4 libpango1.0-0 libstartup-notification0 libstdc++6 libx11-6 libxext6 libxrender1 libxt6 lsb-release)
