# frozen_string_literal: true
package_name = node['travis_build_environment']['elasticsearch']['package_name']
deb_download_dest = File.join(Chef::Config[:file_cache_path], package_name)

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
end

template '/etc/elasticsearch/elasticsearch.yml' do
  source 'etc-elasticsearch-elasticsearch.yml.erb'
  owner  node['travis_build_environment']['user']
  group  node['travis_build_environment']['group']
  mode   '0644'
end

# 🔄 Log before attempting to start the service
ruby_block 'log-before-elasticsearch-start' do
  block do
    Chef::Log.info("🔄 Attempting to start the Elasticsearch service...")
  end
end

# 🟢 Service definition with retry logic
service 'elasticsearch' do
  if node['travis_build_environment']['elasticsearch']['service_enabled']
    action %i(enable start)
    notifies :run, 'ruby_block[check-elasticsearch-service-status]', :immediately
  else
    action %i(disable start)
  end
  retries     4
  retry_delay 90
end

# 📝 Post-start log for service status and logs
ruby_block 'check-elasticsearch-service-status' do
  block do
    status_output = shell_out('systemctl status elasticsearch.service || true').stdout
    journal_output = shell_out('journalctl -xe -n 50 -u elasticsearch.service || true').stdout

    Chef::Log.info("ℹ️ Elasticsearch service status: \n#{status_output}")
    Chef::Log.info("📝 Elasticsearch journal logs: \n#{journal_output}")

    if status_output.include?('failed') || !status_output.include?('active (running)')
      Chef::Log.error("❌ Elasticsearch service failed to start properly. Check the logs above.")
    else
      Chef::Log.info("✅ Elasticsearch started successfully.")
    end
  end
  action :nothing
end

# Trigger pre-start and start logic
ruby_block 'log-before-elasticsearch-start-run' do
  block {}
  notifies :run, 'ruby_block[log-before-elasticsearch-start]', :immediately
  notifies :run, 'service[elasticsearch]', :immediately
end
