include_recipe 'runit'
include_recipe 'jruby'

users = if Chef::Config[:solo]
          node[:users]
        else
          search(:users)
        end

execute "monit-reload" do
  action :nothing
  command "monit reload"
end

service "travis-worker" do
  action :nothing
end

directory node[:travis][:worker][:home] do
  action :create
  recursive true
  owner "travis"  
  group "travis"
  mode "0755"
end

git node[:travis][:worker][:home] do
  repository node[:travis][:worker][:repository]
  reference node[:travis][:worker][:ref]
  action :sync
  user "travis"
  group "travis"
  notifies :restart, resources(:service => 'travis-worker')
end

directory "#{node[:travis][:worker][:home]}/log" do
  action :create
  owner "travis"  
  group "travis"
  mode "0755"
end

directory "#{node[:travis][:worker][:home]}/.VirtualBox" do
  action :create
  owner "travis"
  group "travis"
  mode "0755"
end

home = node[:etc][:passwd][:travis] ? node[:etc][:passwd][:travis][:dir] : users.find{|user| user["id"] == 'travis'}[:home]

link "#{node[:travis][:worker][:home]}/.VirtualBox/VirtualBox.xml" do
  to "#{home}/.VirtualBox/VirtualBox.xml"
  action :create
  link_type :symbolic
  owner "travis"
  group "travis"
  not_if {
    File.exists?("#{node[:travis][:worker][:home]}/.VirtualBox/VirtualBox.xml")
  }
end

bash "bundle gems" do
  code "#{File.dirname(node[:jruby][:bin])}/bundle install --deployment --binstubs"
  user "travis"
  group "travis"
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
  notifies :restart, resources(:service => 'travis-worker')
end

bash "download VirtualBox images" do
  if node[:travis][:worker][:box]
    code "#{node[:jruby][:bin]} ./bin/thor travis:vms:download #{node[:travis][:worker][:box]} 2>/dev/null"
    not_if {
      File.exists?("#{node[:travis][:worker][:home]}/boxes/travis-#{node[:travis][:worker][:env]}-pro.box")
    }
  else
    code "#{node[:jruby][:bin]} ./bin/thor travis:vms:download 2>/dev/null"
    not_if {
      File.exists?("#{node[:travis][:worker][:home]}/boxes/travis-#{node[:travis][:worker][:env]}.box")
    }
  end

  user "travis"
  group "travis"
  cwd node[:travis][:worker][:home]
  notifies :restart, resources(:service => 'travis-worker')
  environment({"HOME" => home})
end

bash "copy box image" do
  code "cp #{node[:travis][:worker][:home]}/boxes/travis-#{node[:travis][:worker][:env]}-pro.box #{node[:travis][:worker][:home]}/boxes/travis-#{node[:travis][:worker][:env]}.box"
  user "travis"
  group "travis"
  cwd node[:travis][:worker][:home]
  not_if {
    File.exists?("#{node[:travis][:worker][:home]}/boxes/travis-#{node[:travis][:worker][:env]}.box")
  }
  only_if {
    File.exists?("#{node[:travis][:worker][:home]}/boxes/travis-#{node[:travis][:worker][:env]}-pro.box")
  }
end

bash "create VirtualBox images" do
  code "#{node[:jruby][:bin]} ./bin/thor travis:vms:create &>/tmp/vbox-create.log"
  user "travis"
  group "travis"
  cwd node[:travis][:worker][:home]
  environment({"HOME" => home})
  not_if {
    File.exists?("#{node[:travis][:worker][:home]}/../VirtualBox VMs/travis-#{node[:travis][:worker][:env]}-1")
  }
  notifies :restart, resources(:service => 'travis-worker')
end

runit_service "travis-worker" do
  options :jruby => node[:jruby][:bin],
          :worker_home => node[:travis][:worker][:home],
          :user => "travis",
          :group => "travis"
end

template "/etc/monit/conf.d/travis-worker.monitrc" do
  source "travis-worker.monitrc.erb"
  owner "root"
  group "root"
  mode "0644"
  variables :home => node[:travis][:worker][:home]
  notifies :run, resources(:execute => 'monit-reload')
end
