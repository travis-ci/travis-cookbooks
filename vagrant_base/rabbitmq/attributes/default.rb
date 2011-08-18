default[:rabbitmq][:nodename]  = node[:hostname]
default[:rabbitmq][:address]  = nil
default[:rabbitmq][:port]  = nil
default[:rabbitmq][:config] = nil
default[:rabbitmq][:logdir] = nil
default[:rabbitmq][:mnesiadir] = nil
#clustering
default[:rabbitmq][:cluster] = "no"
default[:rabbitmq][:cluster_config] = "/etc/rabbitmq/rabbitmq_cluster.config"
default[:rabbitmq][:cluster_disk_nodes] = []
#plugins
default[:rabbitmq][:version] = '2.5.1'
default[:rabbitmq][:plugin_directory] = "/usr/lib/rabbitmq/lib/rabbitmq_server-#{node[:rabbitmq][:version]}/plugins"

