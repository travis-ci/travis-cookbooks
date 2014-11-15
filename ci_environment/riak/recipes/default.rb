case node['lsb']['codename']
when 'trusty'
  require "tmpdir"
  require "uri"

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

  package "Install Riak #{node['riak']['package']['version']}" do
    ignore_failure true
    action         :install
    package_name   'riak'
    version        node["riak"]["package"]["version"]
  end

when 'precise'
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
end

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
