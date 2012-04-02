execute "monit-reload-travis-worker" do
  action :nothing
  command "monit reload travis-worker"
end

directory node[:travis][:worker][:home] do
  action :create
  recursive true
  owner "travis"  
  group "travis"
  mode "0755"
end

directory "#{node[:travis][:worker][:home]}/log" do
  action :create
  owner "travis"  
  group "travis"
  mode "0755"
end

git "#{node[:travis][:worker][:home]}" do
  repository node[:travis][:worker][:repository]
  reference node[:travis][:worker][:ref]
  action :sync
  user "travis"
  user "travis"
end

rvm  = "source /usr/local/rvm/scripts/rvm && rvm"
nohup_rvm  = "source /usr/local/rvm/scripts/rvm && nohup rvm"

bash "bundle gems" do
  code "#{rvm} jruby do bundle install --path vendor/bundle"
  user "travis"
  cwd node[:travis][:worker][:home]
end

bash "update VirtualBox images" do
  code "#{rvm} jruby do bundle exec thor travis:vms:update -r -d 2>/dev/null"
  user "travis"
  cwd node[:travis][:worker][:home]
  not_if {
    File.exists?("#{node[:travis][:worker][:home]}/boxes/travis-#{node[:travis][:worker][:env]}.box")
  }
end

template "#{node[:travis][:worker][:home]}/config/worker.yml" do
  source "worker.yml.erb"
  owner "travis"
  group "travis"
  mode "0600"
  variables :amqp => node[:travis][:worker][:amqp],
            :env => node[:travis][:worker][:env],
            :vms => node[:travis][:worker][:vms]
  notifies :reload, resources(:execute => 'monit-reload-travis-worker')
end

