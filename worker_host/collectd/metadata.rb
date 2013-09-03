name             "collectd"
maintainer       "Noan Kantrowitz"
maintainer_email "nkantrowitz@crypticstudios.com"
license          "Apache 2.0"
description      "Install and configure the collectd monitoring daemon"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "1.0.3"
supports         "ubuntu"

recipe "collectd", "Installs collectd standalone"
recipe "collectd::client", "Installs collectd client"
recipe "collectd::server", "Installs collectd server"
# 
# recipe "collectd::collectd_web", "Installs collectd web interface", 
# 'collected_web' disabled as workaround to Chef11 CookbookNotFound exception 
# when provisioning without cookbook dependency management (Librarian/Berkshelf)
#
# Required for collectd_web recipe
# depends "apache2"
