execute "monit-reload" do
  action :nothing
  command "monit reload"
end

execute "monit-restart-travis-worker" do
  action :nothing
  command "monit restart travis-worker"
end

directory node[:travis][:worker][:home] do
  action :create
  recursive true
  owner "travis"  
  group "travis"
  mode "0755"
end

git "#{node[:travis][:worker][:home]}" do
  repository node[:travis][:worker][:repository]
  reference node[:travis][:worker][:ref]
  action :sync
  user "travis"
  group "travis"
  notifies :run, resources(:execute => 'monit-restart-travis-worker')
end

directory "#{node[:travis][:worker][:home]}/log" do
  action :create
  owner "travis"  
  group "travis"
  mode "0755"
end

if not node[:travis][:worker][:post_checkout].empty?
  bash "run post checkout hook (#{node[:travis][:worker][:post_checkout][:command]})" do
    code node[:travis][:worker][:post_checkout][:command]
    user "travis"
    not_if "cd #{node[:travis][:worker][:home]} && #{node[:travis][:worker][:post_checkout][:condition]}"
    cwd node[:travis][:worker][:home]
  end
end

rvm  = "source /usr/local/rvm/scripts/rvm && rvm"
nohup_rvm  = "source /usr/local/rvm/scripts/rvm && nohup rvm"

bash "bundle gems" do
  code "#{rvm} jruby do bundle install --path vendor/bundle --binstubs"
  user "travis"
  cwd node[:travis][:worker][:home]
end

template "#{node[:travis][:worker][:home]}/config/worker.yml" do
  source "worker.yml.erb"
  owner "travis"
  group "travis"
  mode "0600"
  variables :amqp => node[:travis][:worker][:amqp],
            :env => node[:travis][:worker][:env],
            :vms => node[:travis][:worker][:vms]
  notifies :run, resources(:execute => 'monit-restart-travis-worker')
end

bash "download VirtualBox images" do
  code "#{rvm} jruby do ./bin/thor travis:vms:download 2>/dev/null"
  user "travis"
  cwd node[:travis][:worker][:home]
  not_if {
    File.exists?("#{node[:travis][:worker][:home]}/boxes/travis-#{node[:travis][:worker][:env]}.box")
  }
  notifies :run, resources(:execute => 'monit-restart-travis-worker')
end

bash "create VirtualBox images" do
  code "#{rvm} jruby do bundle exec thor travis:vms:create"
  user "travis"
  cwd node[:travis][:worker][:home]
  notifies :run, resources(:execute => 'monit-restart-travis-worker')
  not_if {
    File.exists?("#{node[:travis][:worker][:home]}/../VirtualBox VMs/travis-#{node[:travis][:worker][:env]}-1")
  }
end

template "/etc/monit/conf.d/travis-worker.monitrc" do
  source "travis-worker.monitrc.erb"
  owner "root"
  group "root"
  mode "0644"
  variables :home => node[:travis][:worker][:home]
  notifies :run, resources(:execute => 'monit-reload')
end
