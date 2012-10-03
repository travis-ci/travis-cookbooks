include_attribute "rvm::default"

default[:rvm][:rubies]       = [{ :name => "1.8.7" },
                                { :name => "1.9.3" }]
default[:rvm][:default]      = "1.9.3"
default[:rvm][:aliases]      = Hash.new
