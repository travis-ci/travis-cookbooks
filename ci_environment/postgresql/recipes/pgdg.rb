#
# Use packages from PostgreSQL Global Development Group
#
apt_repository 'pgdg' do
  uri 'http://apt.postgresql.org/pub/repos/apt/'
  distribution "#{node['lsb']['codename']}-pgdg"
  components ["main"]
  key 'http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc'

  action :add
end

