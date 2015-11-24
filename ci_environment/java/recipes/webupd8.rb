
package "debconf-utils"
package "curl"

apt_repository "webupd8team-java-ppa" do
  uri          "http://ppa.launchpad.net/webupd8team/java/ubuntu"
  distribution node['lsb']['codename']
  components   ["main"]
  key          "EEA14886"
  keyserver    "keyserver.ubuntu.com"

  action :add
end

#
# Ensure that the Ubuntu Java keystore is installed, so that
# we can symlink it from Oracle JDKs and thus having all JDKs
# behave the same when reaching HTTPS sites (e.g. repositories).
#
# Ubuntu keystore currently contains 152 certificates (with StartSSL,...)
# while Oracle/Webupd8 keystore only contains 78 certificates.
#
# Note: 'openjdk-6-jre-headless' or 'java6-runtime-headless'
#        will be auto-installed as dependency (a bit noisy, but it shoudn't hurt)
#
# Possible variant: install a copy of ubuntu java keystore as cookbook_file or remote_file
#
package "ca-certificates-java"
