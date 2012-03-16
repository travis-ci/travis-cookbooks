git "#{node[:travis][:worker][:home]}" do
  repository node[:travis][:worker][:repository]
  reference node[:travis][:worker][:ref]
  action :sync
  user "travis"
  user "travis"
end

template "#{node[:travis][:worker][:home]}/config/worker.yml" do
  source "worker.yml.erb"
  owner "travis"
  group "travis"
  mode "0600"
  variables :amqp => node[:travis][:worker][:amqp],
            :env => node[:travis][:worker][:env],
            :vms => node[:travis][:worker][:vms]
end

execute "bundle gems" do
  command "rvm 1.9.2 do bundle install"
  user "travis"
  cwd node[:travis][:worker][:home]
end
