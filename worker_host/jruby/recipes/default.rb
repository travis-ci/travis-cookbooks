ENV['PATH'] = "#{ENV['PATH']}:/opt/jruby/bin"

include_recipe "java"

package "libjffi-jni" do
  action :install
end

remote_file "/var/tmp/jruby-bin-#{node[:jruby][:version]}.tar.gz" do
  source "http://jruby.org.s3.amazonaws.com/downloads/#{node[:jruby][:version]}/jruby-bin-#{node[:jruby][:version]}.tar.gz"
  action :create_if_missing
end

directory "/opt/jruby" do
  owner "root"
  group "root"
  mode "0755"
end

execute "extract JRuby" do
  command "tar -C /opt/jruby --strip-components=1 -zxf /var/tmp/jruby-bin-#{node[:jruby][:version]}.tar.gz"
end

(node[:jruby][:gems] || %w{rake bundler}).each do |gem|
  gem_package gem do
    gem_binary "/opt/jruby/bin/jgem"
    action :install
    options "--no-ri --no-rdoc"
  end
end
