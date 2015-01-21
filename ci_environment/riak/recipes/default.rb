#
# Use Basho via APT to PACKAGECLOUD repository
#
package 'apt-transport-https' do
  action :install
end

apt_repository 'basho-riak' do
  uri          'https://packagecloud.io/basho/riak/ubuntu/'
  distribution node["lsb"]["codename"]
  components   ["main"]
  key          'https://packagecloud.io/gpg.key'

  action :add
end

package 'riak' do
  action :install
end

#
# - Stop riak service to customize configuration files
# - Don't enable riak service at server boot time
#
service 'riak' do
  supports :status => true, :restart => true
  action [:disable, :stop]
end

template "/etc/riak/riak.conf" do
  source "riak.conf.erb"
  owner  'riak'
  group  'riak'
  mode   0644
end
