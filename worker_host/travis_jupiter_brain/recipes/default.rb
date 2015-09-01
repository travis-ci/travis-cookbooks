remote_file '/usr/local/bin/jb-server' do
  source sprintf(
    node['travis_jupiter_brain']['install_base_url'],
    node['travis_jupiter_brain']['install_version']
  )
  checksum node['travis_jupiter_brain']['install_checksum']
  owner 'root'
  group 'root'
  mode 0755
end

Array(node['travis_jupiter_brain']['install_instances']).each do |instance|
  template "/etc/init/#{instance['service_name']}.conf" do
    source 'upstart.conf.erb'
    owner 'root'
    group 'root'
    mode 0644
    variables instance
  end

  template "/etc/default/#{instance['service_name']}" do
    source 'etc-default.erb'
    owner 'root'
    group 'root'
    mode 0644
    variables instance
  end
end
