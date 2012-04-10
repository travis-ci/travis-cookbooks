include_recipe 'apt'

apt_repository "oracle-virtualbox" do
  uri "http://download.virtualbox.org/virtualbox/debian"
  distribution node['lsb']['codename']
  components %w{contrib}
  action :add
  key 'http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc'
end

package "virtualbox-4.1" do
  action :install
end
