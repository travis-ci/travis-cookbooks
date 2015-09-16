default[:jruby][:version] = '1.7.2'
default[:jruby][:arch] = RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'
default[:jruby][:deb] = "jruby_#{node[:jruby][:version]}_#{node[:jruby][:arch]}.deb"
default[:jruby][:deb_url] = "http://travis-packages.s3.amazonaws.com/deb/#{node[:jruby][:deb]}"
default[:jruby][:bin] = '/opt/jruby/bin/jruby'
