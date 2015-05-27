#
# Use packages from PostgreSQL Global Development Group
#
apt_repository 'pgdg' do
  uri 'http://apt.postgresql.org/pub/repos/apt/'
  distribution "#{node['lsb']['codename']}-pgdg"
  # 9.4 component is needed to install related libpq5 dependencies
  # See https://wiki.postgresql.org/wiki/Apt/FAQ#I_want_to_try_the_beta_version_of_the_next_PostgreSQL_release
  components ["main", "9.4"]
  key 'http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc'

  action :add
end

