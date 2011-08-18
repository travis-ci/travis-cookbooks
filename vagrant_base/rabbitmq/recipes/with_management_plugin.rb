#
# Cookbook Name:: rabbitmq
# Recipe:: with_management_plugin
#

include_recipe "rabbitmq::default"

remote_file "#{node[:rabbitmq][:plugin_directory]}mochiweb.ez" do
  source "http://www.rabbitmq.com/releases/plugins/v2.5.1/mochiweb-1.3-rmq2.5.1-git9a53dbd.ez"
end

remote_file "#{node[:rabbitmq][:plugin_directory]}webmachine.ez" do
  source "http://www.rabbitmq.com/releases/plugins/v2.5.1/webmachine-1.7.0-rmq2.5.1-hg0c4b60a.ez"
end

remote_file "#{node[:rabbitmq][:plugin_directory]}rabbitmq_mochiweb.ez" do
  source "http://www.rabbitmq.com/releases/plugins/v2.5.1/rabbitmq_mochiweb-2.5.1.ez"
end

remote_file "#{node[:rabbitmq][:plugin_directory]}amqp_client.ez" do
  source "http://www.rabbitmq.com/releases/plugins/v2.5.1/amqp_client-2.5.1.ez"
end

remote_file "#{node[:rabbitmq][:plugin_directory]}rabbitmq_management_agent.ez" do
  source "http://www.rabbitmq.com/releases/plugins/v2.5.1/rabbitmq_management_agent-2.5.1.ez"
end

remote_file "#{node[:rabbitmq][:plugin_directory]}rabbitmq_management.ez" do
  source "http://www.rabbitmq.com/releases/plugins/v2.5.1/rabbitmq_management-2.5.1.ez"
end
