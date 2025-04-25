## Cookbook Name:: travis_build_environment
## Recipe:: elasticsearch

# Ensure line cookbook is available for replace_or_add resource
include_recipe 'line'

package_name      = node['travis_build_environment']['elasticsearch']['package_name']
deb_download_dest = ::File.join(Chef::Config[:file_cache_path], package_name)

# Download Elasticsearch package
remote_file deb_download_dest do
  source "https://artifacts.elastic.co/downloads/elasticsearch/#{package_name}"
  owner  node['travis_build_environment']['user']
  group  node['travis_build_environment']['group']
  mode   '0644'
end

# Install DEB if not already present
dpkg_package package_name do
  source     deb_download_dest
  action     :install
  not_if     { ::File.exist?('/usr/share/elasticsearch/bin/elasticsearch') }
  notifies   :run, 'ruby_block[print-elasticsearch-config-before]', :before
  notifies   :run, 'ruby_block[create-symbolic-links]', :immediately
  notifies   :run, 'ruby_block[disable-xpack-security]', :immediately
end

# Log config before modifications
ruby_block 'print-elasticsearch-config-before' do
  block do
    cfg = ::File.read('/etc/elasticsearch/elasticsearch.yml')
    Chef::Log.info("=== Elasticsearch configuration before (elasticsearch.yml) ===\n#{cfg}")
  end
  action :nothing
end

# Create symlinks for each Elasticsearch binary
Dir.glob('/usr/share/elasticsearch/bin/*').each do |src|
  bin_name = ::File.basename(src)
  link "/usr/local/bin/#{bin_name}" do
    to      src
    owner   node['travis_build_environment']['user']
    group   node['travis_build_environment']['group']
    action  :create
    not_if  { ::File.exist?("/usr/local/bin/#{bin_name}") }
  end
end

# Disable X-Pack security in elasticsearch.yml
replace_or_add 'disable xpack security' do
  path    '/etc/elasticsearch/elasticsearch.yml'
  pattern /^xpack\.security\.enabled\s*:/
  line    'xpack.security.enabled: false'
end

# Configure JVM heap settings
template '/etc/elasticsearch/jvm.options' do
  source   'etc-elasticsearch-jvm.options.erb'
  owner    node['travis_build_environment']['user']
  group    node['travis_build_environment']['group']
  mode     '0644'
  variables(
    jvm_heap: node['travis_build_environment']['elasticsearch']['jvm_heap']
  )
  notifies :restart, 'service[elasticsearch]', :immediately
end

# Log config after modifications
ruby_block 'print-elasticsearch-config-after' do
  block do
    cfg = ::File.read('/etc/elasticsearch/elasticsearch.yml')
    Chef::Log.info("=== Elasticsearch configuration after (elasticsearch.yml) ===\n#{cfg}")
  end
  action :nothing
end

# Manage Elasticsearch service
service 'elasticsearch' do
  if node['travis_build_environment']['elasticsearch']['service_enabled']
    action [:enable, :start]
  else
    action [:disable, :start]
  end
  retries     4
  retry_delay 30
  notifies :run, 'ruby_block[print-elasticsearch-config-after]', :immediately
end
