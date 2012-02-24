default[:rvm][:rubies]       = [{ :name => "1.8.7" },
                                { :name => "1.9.3" }]
default[:rvm][:default]      = "1.8.7"
default[:rvm][:default_gems] = %w(bundler rake)
default[:rvm][:aliases]      = Hash.new

# ruby-head revision that is known to build fine. MK.
default[:rvm][:rvm_ruby_sha] = "7d742d47cc2f0023c4aeffdec6a6296f6c69a10f"
