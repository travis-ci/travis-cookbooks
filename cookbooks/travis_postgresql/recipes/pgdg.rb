# frozen_string_literal: true

# Xenial and Bionic removed from the official PostgreSQL apt repository
case node['lsb']['codename']
when 'xenial', 'bionic'
  pgp_uri = 'https://apt-archive.postgresql.org/pub/repos/apt'
else
  pgp_uri = 'http://apt.postgresql.org/pub/repos/apt/'
end

apt_repository 'pgdg' do
  uri pgp_uri
  distribution "#{node['lsb']['codename']}-pgdg"
  components %w(main)
  key 'http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc'
  retries 2
  retry_delay 30
  action :add
end

apt_update 'update'
