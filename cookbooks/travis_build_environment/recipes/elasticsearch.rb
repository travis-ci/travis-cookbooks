# frozen_string_literal: true

package_name      = node['travis_build_environment']['elasticsearch']['package_name']
deb_download_dest = File.join(Chef::Config[:file_cache_path], package_name)

remote_file deb_download_dest do
  source "https://artifacts.elastic.co/downloads/elasticsearch/#{package_name}"
  owner  node['travis_build_environment']['user']
  group  node['travis_build_environment']['group']
  mode   '0644'
end

dpkg_package package_name do
  source     deb_download_dest
  action     :install
  not_if     'which elasticsearch'
  notifies   :run, 'ruby_block[create-symbolic-links]', :immediately
  notifies   :run, 'ruby_block[disable-xpack-security]', :immediately
end

ruby_block 'create-symbolic-links' do
  block do
    Dir.foreach('/usr/share/elasticsearch/bin') do |file|
      next if %w(. ..).include?(file)
      src = "/usr/share/elasticsearch/bin/#{file}"
      dst = "/usr/local/bin/#{file}"
      File.symlink(src, dst) unless File.exist?(dst)
    end
  end
  action :nothing
end

template '/etc/elasticsearch/jvm.options' do
  source   'etc-elasticsearch-jvm.options.erb'
  owner    node['travis_build_environment']['user']
  group    node['travis_build_environment']['group']
  mode     '0644'
  variables(
    jvm_heap: node['travis_build_environment']['elasticsearch']['jvm_heap']
  )
end

ruby_block 'print-elasticsearch-config' do
  block do
    cfg = ::File.read('/etc/elasticsearch/elasticsearch.yml')
    Chef::Log.info("=== Elasticsearch configuration (elasticsearch.yml) ===\n\n#{cfg}")
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
  end
  action :nothing
end

service 'elasticsearch' do
  if node['travis_build_environment']['elasticsearch']['service_enabled']
    action %i(enable start)
  else
    action %i(disable start)
  end
  retries     4
  retry_delay 30
  notifies :run, 'ruby_block[print-elasticsearch-config]', :immediately
end
