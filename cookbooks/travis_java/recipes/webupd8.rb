# frozen_string_literal: true

package %w(
  curl
  debconf-utils
)

apt_repository 'webupd8team-java-ppa' do
  uri 'ppa:webupd8team/java'
  components %w(main)
  key 'EEA14886'
  keyserver 'hkp://ha.pool.sks-keyservers.net'
  retries 2
  retry_delay 30
  action :add
end

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
package 'ca-certificates-java'
