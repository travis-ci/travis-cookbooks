# frozen_string_literal: true

apt_repository 'openjdk-r-java-ppa' do
  uri 'ppa:openjdk-r/ppa'
  retries 2
  retry_delay 30
  action :add
end
