require "tmpdir"
require "uri"

remote_file "#{Chef::Config[:file_cache_path]}/riak_installer" do
  source node["riak"]["package"]["installer"]
  owner  node["travis_build_environment"]["user"]
  group  node["travis_build_environment"]["group"]
  mode   0755
end

bash "run Riak installer" do
  user "root"
  code "#{Chef::Config[:file_cache_path]}/riak_installer"
end

package "Install Riak #{node['riak']['package']['version']}" do
  ignore_failure true
  action         :install
  package_name   'riak'
  version        node["riak"]["package"]["version"]
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
