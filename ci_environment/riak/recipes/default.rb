#
# Use Basho APT repository
#
apt_repository 'basho' do
  uri          'http://apt.basho.com'
  distribution node['lsb']['codename']
  components   ["main"]
  key          'http://apt.basho.com/gpg/basho.apt.key'

  action :add
end

package 'riak'

#
# - Stop riak service to customize configuration files
# - Don't enable riak service at server boot time
#
service 'riak' do
  action [:disable, :stop]
end

template "/etc/riak/app.config" do
  source "app.config.erb"
  owner  'riak'
  group  'riak'
  mode   0644
end

template "/etc/riak/vm.args" do
  source "vm.args.erb"
  owner  'riak'
  group  'riak'
  mode   0644
end
