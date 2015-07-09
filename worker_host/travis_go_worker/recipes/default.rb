packagecloud_repo "travisci/worker" do
  type "deb"
end

package "travis-worker" do
  action :install
end

service "travis-worker" do
  provider Chef::Provider::Service::Upstart
  action :start
end

if node[:travis][:worker].key?(:branch)
  remote_file "/usr/local/bin/travis-worker" do
    source "https://travis-worker-artifacts.s3.amazonaws.com/travis-ci/worker/<%= node[:travis][:worker][:branch] %>/build/linux/amd64/travis-worker"
    owner "root"
    group "root"
    mode "0755"

    notifies :restart, resources(:service => "travis-worker")
  end
end

template "/etc/default/travis-worker" do
  source "travis-worker.erb"
  owner "root"
  group "root"
  mode "0644"
  variables :settings => node[:travis][:worker][:settings]

  notifies :restart, resources(:service => "travis-worker")
end
