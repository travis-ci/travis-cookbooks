# frozen_string_literal: true

package_name      = node['travis_build_environment']['elasticsearch']['package_name']
deb_download_dest = ::File.join(Chef::Config[:file_cache_path], package_name)

log 'remote_file_downloaded' do
  message "Elasticsearch package #{package_name} pobrany do #{deb_download_dest}"
  level   :info
  action  :nothing
end

log 'package_installed' do
  message "Elasticsearch #{package_name} zainstalowany"
  level   :info
  action  :nothing
end

log 'symlinks_created' do
  message 'Utworzono symlinki CLI Elasticsearch w /usr/local/bin'
  level   :info
  action  :nothing
end

log 'jvm_template_applied' do
  message 'Zastosowano szablon /etc/elasticsearch/jvm.options'
  level   :info
  action  :nothing
end

log 'xpack_disabled' do
  message 'Wyłączono xpack.security.enabled w elasticsearch.yml'
  level   :info
  action  :nothing
end

log 'service_started' do
  message 'Serwis elasticsearch został włączony/wyłączony i wystartowany'
  level   :info
  action  :nothing
end

ruby_block 'print-elasticsearch-logs' do
  block do
    log_path = '/var/log/elasticsearch/elasticsearch.log'
    if ::File.exist?(log_path)
      lines = ::File.readlines(log_path).last(20)
      Chef::Log.info("=== Ostatnie 20 linii z #{log_path} ===\n#{lines.join}")
    else
      Chef::Log.warn("Nie znaleziono pliku logów pod ścieżką #{log_path}")
    end
  end
  action :nothing
end

execute 'systemctl-daemon-reload' do
  command 'systemctl daemon-reload'
  action  :nothing
end

remote_file deb_download_dest do
  source   "https://artifacts.elastic.co/downloads/elasticsearch/#{package_name}"
  owner    node['travis_build_environment']['user']
  group    node['travis_build_environment']['group']
  mode     '0644'
  not_if   { ::File.exist?(deb_download_dest) }
  notifies :write,   'log[remote_file_downloaded]',   :immediately
end

dpkg_package package_name do
  source   deb_download_dest
  action   :install
  not_if   'which elasticsearch'
  notifies :run,     'execute[systemctl-daemon-reload]', :immediately
  notifies :run,     'ruby_block[create-symbolic-links]',  :immediately
  notifies :run,     'ruby_block[disable-xpack-security]', :immediately
  notifies :write,   'log[package_installed]',            :immediately
end

ruby_block 'create-symbolic-links' do
  block do
    created = []
    Dir.foreach('/usr/share/elasticsearch/bin') do |file|
      next if %w(. ..).include?(file)
      src = "/usr/share/elasticsearch/bin/#{file}"
      dst = "/usr/local/bin/#{file}"
      unless ::File.exist?(dst)
        File.symlink(src, dst)
        created << file
      end
    end
    Chef::Log.info(created.any? ? "Symlinki utworzone: #{created.join(', ')}" : 'Symlinki już istniały')
  end
  action :nothing
  notifies :write, 'log[symlinks_created]', :immediately
end

template '/etc/elasticsearch/jvm.options' do
  source   'etc-elasticsearch-jvm.options.erb'
  owner    node['travis_build_environment']['user']
  group    node['travis_build_environment']['group']
  mode     '0644'
  variables(
    jvm_heap: node['travis_build_environment']['elasticsearch']['jvm_heap']
  )
  notifies :write,   'log[jvm_template_applied]',       :immediately
  notifies :run,     'execute[systemctl-daemon-reload]', :immediately
  notifies :restart, 'service[elasticsearch]',          :delayed
end

ruby_block 'print-elasticsearch-config' do
  block do
    cfg = ::File.read('/etc/elasticsearch/elasticsearch.yml')
    Chef::Log.info("=== elasticsearch.yml ===\n\n#{cfg}")
  end
  action :nothing
end

ruby_block 'disable-xpack-security' do
  block do
    require 'chef/util/file_edit'
    edit = Chef::Util::FileEdit.new('/etc/elasticsearch/elasticsearch.yml')
    edit.search_file_replace_line(
      /^xpack\.security\.enabled\s*:/,
      'xpack.security.enabled: false'
    )
    edit.insert_line_if_no_match(
      /^xpack\.security\.enabled\s*:/,
      'xpack.security.enabled: false'
    )
    edit.write_file
    Chef::Log.info('Wstawiono xpack.security.enabled=false')
  end
  action :nothing
  notifies :write,   'log[xpack_disabled]',            :immediately
  notifies :run,     'execute[systemctl-daemon-reload]', :immediately
  notifies :restart, 'service[elasticsearch]',         :delayed
end

service 'elasticsearch' do
  supports status: true, restart: true, reload: true
  if node['travis_build_environment']['elasticsearch']['service_enabled']
    action %i(enable start)
  else
    action %i(disable start)
  end
  retries     4
  retry_delay 30
  notifies :run,   'ruby_block[print-elasticsearch-config]', :immediately
  notifies :write, 'log[service_started]',                  :immediately
  notifies :run,   'ruby_block[print-elasticsearch-logs]',  :immediately
end
