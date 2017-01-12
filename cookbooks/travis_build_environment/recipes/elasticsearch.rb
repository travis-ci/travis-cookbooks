deb = "elasticsearch-#{node['travis_build_environment']['elasticsearch']['version']}.deb"
path = File.join(Chef::Config[:file_cache_path], deb)

remote_file path do
  source "https://artifacts.elastic.co/downloads/elasticsearch/#{deb}"
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
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

package deb do
  source path
  provider Chef::Provider::Package::Dpkg
  notifies :create, 'ruby_block[create-symbolic-links]'
  action :install
  not_if 'which elasticsearch'
end

service 'elasticsearch' do
  if node['travis_build_environment']['elasticsearch']['service_enabled']
    action %i(enable start)
  else
    action %i(disable start)
  end
  retries 4
  retry_delay 30
end
