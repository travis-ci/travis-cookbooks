# Install MySQL client from deb packages from mysql.com

include_recipe 'mysql::deb'

package 'libaio1'

node.mysql.deb.client.packages.each do |pkg|
  package pkg do
    action :upgrade
  end
end