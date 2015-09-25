ENV['PATH'] = "#{ENV['PATH']}:/opt/jruby/bin"

include_recipe 'travis_java'

package 'libjffi-jni' do
  action :install
end

remote_file "/var/tmp/jruby-bin-#{node[:jruby][:version]}.tar.gz" do
  source "http://jruby.org.s3.amazonaws.com/downloads/#{node[:jruby][:version]}/jruby-bin-#{node[:jruby][:version]}.tar.gz"
  action :create_if_missing
end

directory '/opt/jruby' do
  owner 'root'
  group 'root'
  mode '0755'
end

execute 'extract JRuby' do
  command "tar -C /opt/jruby --strip-components=1 -zxf /var/tmp/jruby-bin-#{node[:jruby][:version]}.tar.gz"
end

(node[:jruby][:gems] || { 'rake' => nil, 'bundler' => nil }).each do |gem, gem_version|
  gem_package gem do
    gem_binary '/opt/jruby/bin/jgem'
    action :install
    version gem_version unless gem_version.nil?
    options '--no-ri --no-rdoc'
  end
end
