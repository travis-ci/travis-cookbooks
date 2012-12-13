ENV['PATH'] = "#{ENV['PATH']}:/opt/jruby/bin"

include_recipe "java"

package "libjffi-jni" do
  action :install
end

remote_file "/var/tmp/#{node[:jruby][:deb]}" do
  source node[:jruby][:deb_url] 
  action :create_if_missing
end

dpkg_package "/var/tmp/#{node[:jruby][:deb]}" do
  action :install
end

(node[:jruby][:gems] || %w{rake bundler}).each do |gem|
  gem_package gem do
    gem_binary "/opt/jruby/bin/jgem"
    action :install
    options "--no-ri --no-rdoc"
  end
end
