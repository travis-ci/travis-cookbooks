# frozen_string_literal: true

apt_repository 'google-chrome' do
  uri 'http://dl.google.com/linux/chrome/deb/'
  arch 'amd64'
  distribution ''
  components %w[stable main]
  key 'https://dl-ssl.google.com/linux/linux_signing_key.pub'
  retries 2
  retry_delay 30
end

package 'google-chrome-stable'

apt_repository 'google-chrome' do
  action :remove
  not_if { node['travis_build_environment']['google_chrome']['keep_repo'] }
end
