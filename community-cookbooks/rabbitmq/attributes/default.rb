default[:rabbitmq][:nodename]  = "rabbit@localhost" # the opscode cookbooks (http://bit.ly/10hiKhg) suggests nil, but then rabbit does not start, but localhost works fine
default[:rabbitmq][:address]  = nil
default[:rabbitmq][:port]  = nil
default[:rabbitmq][:config] = nil
default[:rabbitmq][:logdir] = nil
default[:rabbitmq][:mnesiadir] = nil

default[:rabbitmq][:high_memory_watermark]  = 0.04

default[:rabbitmq][:service][:enabled]      = false

