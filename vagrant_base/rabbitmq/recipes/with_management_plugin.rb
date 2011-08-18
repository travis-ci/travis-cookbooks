#
# Cookbook Name:: rabbitmq
# Recipe:: with_management_plugin
#

include_recipe "rabbitmq::default"

v = node[:rabbitmq][:version]
["mochiweb-1.3-rmq#{v}-git9a53dbd.ez",
"webmachine-1.7.0-rmq#{v}-hg0c4b60a.ez",
"rabbitmq_mochiweb-#{v}.ez",
"amqp_client-#{v}.ez",
"rabbitmq_management_agent-#{v}.ez",
"rabbitmq_management-#{v}.ez"].each do |filename|

  remote_file "#{node[:rabbitmq][:plugin_directory]}/#{filename}" do
    source "http://www.rabbitmq.com/releases/plugins/v#{v}/#{filename}"
    mode '0644'
  end
end 

