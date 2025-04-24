# recipes/elasticsearch.rb
# frozen_string_literal: true

package_name = node['travis_build_environment']['elasticsearch']['package_name']
deb_download_dest = File.join(
  Chef::Config[:file_cache_path],
  package_name
)

remote_file deb_download_dest do
  source "https://artifacts.elastic.co/downloads/elasticsearch/#{package_name}"
  owner  node['travis_build_environment']['user']
  group  node['travis_build_environment']['group']
  mode   '0644'
end

dpkg_package package_name do
  source deb_download_dest
  action :install
  not_if 'which elasticsearch'
  notifies :run, 'ruby_block[create-symbolic-links]', :immediately
end

ruby_block 'create-symbolic-links' do
  block do
    Dir.foreach('/usr/share/elasticsearch/bin') do |file|
      next if file == '.' || file == '..'
      src = "/usr/share/elasticsearch/bin/#{file}"
      dst = "/usr/local/bin/#{file}"
      File.symlink(src, dst) unless File.exist?(dst)
    end
  end
  action :nothing
end

template '/etc/elasticsearch/jvm.options' do
  source 'etc-elasticsearch-jvm.options.erb'
  owner  node['travis_build_environment']['user']
  group  node['travis_build_environment']['group']
  mode   '0644'
  variables(
    jvm_heap: node['travis_build_environment']['elasticsearch']['jvm_heap']
  )
  notifies :restart, 'service[elasticsearch]', :delayed
end

template '/etc/elasticsearch/elasticsearch.yml' do
  source 'etc-elasticsearch-elasticsearch.yml.erb'
  owner  node['travis_build_environment']['user']
  group  node['travis_build_environment']['group']
  mode   '0644'
  variables(
    service_enabled: node['travis_build_environment']['elasticsearch']['service_enabled']
  )
  notifies :restart, 'service[elasticsearch]', :delayed
end

service 'elasticsearch' do
  action [:enable, :start]
  notifies :run, 'ruby_block[check-elasticsearch-service-status]', :immediately if node['travis_build_environment']['elasticsearch']['service_enabled']
end

ruby_block 'check-elasticsearch-service-status' do
  block do
    service_status = shell_out!('systemctl status elasticsearch.service || true')
    journal_logs = shell_out!('journalctl -xe --no-pager -n 50 -u elasticsearch.service || true')
    
    Chef::Log.info("Elasticsearch service status:\n#{service_status.stdout}\n#{service_status.stderr}")
    Chef::Log.info("Elasticsearch journal logs:\n#{journal_logs.stdout}\n#{journal_logs.stderr}")
    
    if service_status.error?
      Chef::Log.error("Elasticsearch service failed to start. Check logs above for details.")
      raise "Failed to start Elasticsearch service"
    end
  end
  action :nothing
end
