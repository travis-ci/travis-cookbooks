#
# Cookbook Name:: rabbitmq
# Recipe:: with_management_plugin
#

include_recipe "rabbitmq::default"

# RabbitMQ 2.7.0 and later ship with plugins bundled, so we just have
# to activate them using rabbitmq-plugins. MK.
bash "enable rabbitmq management plugin" do
  user "root"
  code "rabbitmq-plugins enable rabbitmq_management"
end
