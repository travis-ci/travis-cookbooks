template "/etc/monit/conf.d/mongodb.conf" do
  source 'mongodb-monit.erb'
  notifies_delayed :restart, resources(:service => "monit")
end