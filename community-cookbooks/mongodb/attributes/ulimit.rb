# http://docs.mongodb.org/manual/reference/ulimit/#recommended-settings
default[:mongodb][:ulimit][:fsize] = 'unlimited' # file_size
default[:mongodb][:ulimit][:cpu] = 'unlimited' # cpu_time
default[:mongodb][:ulimit][:as] = 'unlimited' # virtual memory
default[:mongodb][:ulimit][:nofile] = 64_000 # number_files
default[:mongodb][:ulimit][:rss] = 'unlimited' # memory_size
default[:mongodb][:ulimit][:nproc] = 32_000 # processes
