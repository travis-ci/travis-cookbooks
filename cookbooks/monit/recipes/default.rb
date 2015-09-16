package "monit" do
  action :install
end

execute "monit-reload" do
  action :nothing  
  command "monit reload"
end

cookbook_file "/etc/default/monit" do
  source "default.monit"
  owner "root"
  group "root"
  mode "0644"
  backup false
end

service "monit" do
  supports :start => true, :restart => true, :reload => true
  action [:enable, :start]
  ignore_failure true
end

template "/etc/monit/monitrc" do
  source "monitrc.erb"
  owner "root"
  group "root"
  mode "0600"
  variables :monit => node[:monit]
  notifies :run, resources(:execute => "monit-reload")
end

if node[:monit][:checks][:enabled].any?
  if node[:monit][:alerts].any?
    template "/etc/monit/conf.d/alerts.monitrc" do
      source "alerts.erb"
      owner "root"
      group "root"
      mode "0600"
      variables :alerts => node[:monit][:alerts]
      notifies :run, resources(:execute => "monit-reload")
    end
  end

  node[:monit][:checks][:enabled].each do |check|
    data = node[:monit][:checks][check]
    template "/etc/monit/conf.d/#{check}.monitrc" do
      source "#{check}.erb"
      mode "0644"
      owner "root"
      group "root"
      variables :data => data
      notifies :run, resources(:execute => "monit-reload")
    end
  end
end
