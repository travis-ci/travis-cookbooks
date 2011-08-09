default[:rvm][:rubies]       = ["1.8.7", "1.9.2"]
default[:rvm][:default]      = "1.8.7"
default[:rvm][:default_gems] = %w(bundler rake chef)
default[:rvm][:aliases]      = Hash.new
