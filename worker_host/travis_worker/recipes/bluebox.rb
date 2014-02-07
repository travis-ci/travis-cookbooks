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

package "ruby1.9.3" do
  action :install
end

cookbook_file "/usr/local/bin/signal_wrapper" do
  source "signal_wrapper.rb"
  mode "0755"
  owner "root"
  backup false
end

1.upto(node[:travis][:worker][:workers]) do |worker| 
  app = "worker-#{worker}"
  worker_name = "#{app}.#{node[:fqdn]}"
  home = "#{node[:travis][:worker][:home]}/#{app}"
  service_name = "travis-worker-#{worker}"
  host_name = "#{node[:travis][:worker][:hostname]}-#{worker}.#{node[:travis][:worker][:domain]}"

  if node[:travis][:worker][:custom_config] && custom_config = node[:travis][:worker][:custom_config][app]
    vms = custom_config[:vms]
    queue = custom_config[:queue]
  end

  service service_name do
    action :nothing
  end

  directory home do
    action :create
    recursive true
    owner "travis"
    group "travis"
    mode "0755"
  end

  git home do
    repository node[:travis][:worker][:repository]
    reference node[:travis][:worker][:ref]
    action :sync
    user "travis"
    group "travis"
    notifies :restart, resources(:service => service_name)
  end

  directory "#{home}/log" do
    action :create
    owner "travis"  
    group "travis"
    mode "0755"
  end

  bash "bundle gems" do
    code "#{File.dirname(node[:jruby][:bin])}/bundle install --deployment --binstubs"
    user "travis"
    group "travis"
    cwd home
  end

  template "#{home}/config/worker.yml" do
    source "worker-bluebox.yml.erb"
    owner "travis"
    group "travis"
    mode "0600"
    variables :amqp => node[:travis][:worker][:amqp],
              :worker => node[:travis][:worker],
              :hostname => host_name,
              :bluebox => node[:bluebox],
              :librato => node[:collectd_librato],
              :queue => queue,
              :vms => vms

    notifies :restart, resources(:service => service_name)
  end

  runit_service "travis-worker-#{worker}" do
    options :jruby => node[:jruby][:bin],
            :worker_home => home,
            :user => "travis",
            :group => "travis"
    template_name "travis-worker"
  end

  template "/etc/monit/conf.d/travis-worker-#{worker}.monitrc" do
    source "travis-worker-bluebox.monitrc.erb"
    owner "root"
    group "root"
    mode "0644"
    variables :service_name => service_name
    notifies :run, resources(:execute => 'monit-reload')
  end
end
