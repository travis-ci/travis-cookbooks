# frozen_string_literal: true

package_name       = node['travis_build_environment']['elasticsearch']['package_name']
deb_download_dest  = File.join(Chef::Config[:file_cache_path], package_name)

remote_file deb_download_dest do
  source "https://artifacts.elastic.co/downloads/elasticsearch/#{package_name}"
  owner  node['travis_build_environment']['user']
  group  node['travis_build_environment']['group']
  mode   '0644'
end

dpkg_package package_name do
  source  deb_download_dest
  action  :install
  not_if  'which elasticsearch'
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

service 'elasticsearch' do
  action node['travis_build_environment']['elasticsearch']['service_enabled'] ? [:enable] : [:disable]
end

execute 'start elasticsearch' do
  command 'systemctl start elasticsearch.service'
  retries 4
  retry_delay 90
  not_if  'systemctl is-active --quiet elasticsearch.service'
end

execute 'log elasticsearch errors' do
  command <<~EOH
    echo "=== Elasticsearch service status ==="
    systemctl status elasticsearch.service
    echo
    echo "=== Elasticsearch journal (last 50 lines) ==="
    journalctl -xeu elasticsearch.service -n 50
  EOH
  action :run
  only_if 'systemctl is-failed --quiet elasticsearch.service'
end
