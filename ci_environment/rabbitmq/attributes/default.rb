default[:rabbitmq][:nodename]  = nil # as suggested by the opscode cookbooks (http://bit.ly/10hiKhg)
default[:rabbitmq][:address]  = nil
default[:rabbitmq][:port]  = nil
default[:rabbitmq][:config] = nil
default[:rabbitmq][:logdir] = nil
default[:rabbitmq][:mnesiadir] = nil

default[:rabbitmq][:high_memory_watermark]  = 0.04

default[:rabbitmq][:service][:enabled]      = false

