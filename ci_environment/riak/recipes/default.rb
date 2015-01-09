#
# Use Basho via APT to PACKAGECLOUD repository
#
apt_repository 'basho-riak' do
  uri          'https://packagecloud.io/basho/riak/ubuntu/'
  distribution node["lsb"]["codename"]
  components   ["main"]
  key          'https://packagecloud.io/gpg.key'

  remote_file "#{Chef::Config[:file_cache_path]}/riak_script" do
    source node["riak"]["package"]["installer"]
    owner  node["travis_build_environment"]["user"]
    group  node["travis_build_environment"]["group"]
    mode   0755
  end

  bash "run Riak installer" do
    user "root"
    code "#{Chef::Config[:file_cache_path]}/riak_script"
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
