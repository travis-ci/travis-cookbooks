#
# Dynamically compute shared memory limits, based on related application configurations
#
include_attribute 'postgresql::default'

#
# Tune System V shared memory for PostgreSQL up to version 9.2
# Note: PostgreSQL 9.3 switched to Posix shared memory, and therfore makes this kernel tuning obsolete
# See http://wiki.postgresql.org/wiki/What's_new_in_PostgreSQL_9.3#Switch_to_Posix_shared_memory_and_mmap.28.29
#
# ~28-32MB base offset (shared buffer default size, ...) + cost of connections and locks
postgresql_segment_size = (32 * 1024 * 1024) + (48000 * node[:postgresql][:max_connections])

# Maximum size of a single shared memory segment in bytes
default[:sysctl][:kernel_shmmax] = postgresql_segment_size

# Total amount of shared memory available in pages (of 4096 bytes)
# Let's keep this parameter unchanged (by default it is set to 8GB!)
#default[:sysctl][:kernel_shmall] = (postgresql_segment_size/4096.0).ceil

