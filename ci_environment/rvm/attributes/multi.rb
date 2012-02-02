default[:rvm][:rubies]       = [{ :name => "1.8.7" },
                                { :name => "1.9.3" }]
default[:rvm][:default]      = "1.8.7"
default[:rvm][:default_gems] = %w(bundler rake)
default[:rvm][:aliases]      = Hash.new
