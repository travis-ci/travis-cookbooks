# Install MySQL client from deb packages from mysql.com

include_recipe 'mysql::deb'

package 'libaio1'

unless node['mysql']['deb']['client']['packages'].empty?
  package node['mysql']['deb']['client']['packages'] do
    action :upgrade
  end
end
