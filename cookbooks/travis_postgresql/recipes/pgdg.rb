# frozen_string_literal: true

apt_repository 'pgdg' do
  uri 'http://apt.postgresql.org/pub/repos/apt/'
  distribution "#{node['lsb']['codename']}-pgdg"
  components %w[main]
  key 'http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc'
  retries 2
  retry_delay 30
  action :add
end
