default['mysql']['deb']['version'] = '5.6.23'

default['mysql']['deb']['config']['version'] = '0.3.3'

default['mysql']['deb']['checksum'] = {
  '14.04' => {
    '5.6.23' => 'df869344a50a58f2c356c71e71ddfa5e62ff7e187ab8fd3b1ac2e97d98ef963f'
  },
  '12.04' => {
    '5.6.23' => '8d5340fab12dc1d3fa537d59265def5d8e60fba3320710625723dbdaed44c68c'
  }
}

# the order is important, since we invoke dpkg_package with one
# package at a time, and dependency resolution is not possible
default['mysql']['deb']['client']['packages'] = %w(
  mysql-common
  mysql-community-client
  mysql-client
  libmysqlclient18
  libmysqlclient-dev
)
default['mysql']['deb']['server']['packages'] = %w(
  mysql-community-server
  mysql-server
)