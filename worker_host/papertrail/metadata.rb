maintainer       "Librato, Inc."
maintainer_email "mike@librato.com"
license          "Apache 2.0"
description      "Installs/Configures Sys Logging to papertrailapp.com"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.7"
name             "papertrail"

depends          "rsyslog"

# TODO: test on fedora
%w{ubuntu}.each do |os|
  supports os
end

recipe           "papertrail", "Installs/Configures logging to papertrailapp.com"
