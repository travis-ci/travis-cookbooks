# frozen_string_literal: true

package_name = "elasticsearch-#{node['travis_build_environment']['elasticsearch']['version']}.deb"
deb_download_dest = File.join(
  Chef::Config[:file_cache_path],
  package_name
)

remote_file deb_download_dest do
  source "https://artifacts.elastic.co/downloads/elasticsearch/#{package_name}"
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
end

dpkg_package package_name do
  source deb_download_dest
  notifies :run, 'ruby_block[create-symbolic-links]'
  action :install
  not_if 'which elasticsearch'
end

ruby_block 'create-symbolic-links' do
  block do
    Dir.foreach('/usr/share/elasticsearch/bin') do |file|
      unless File.exist? "/usr/local/bin/#{file}"
        File.symlink(
          "/usr/share/elasticsearch/bin/#{file}",
          "/usr/local/bin/#{file}"
        )
      end
    end
  end
  action :nothing
end

template '/etc/elasticsearch/jvm.options' do
  source 'etc-elasticsearch-jvm.options.erb'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o644
  variables(
    jvm_heap: node['travis_build_environment']['elasticsearch']['jvm_heap']
  )
end

service 'elasticsearch' do
  if node['travis_build_environment']['elasticsearch']['service_enabled']
    action %i[enable start]
  else
    action %i[disable start]
  end
  retries 4
  retry_delay 30
end
