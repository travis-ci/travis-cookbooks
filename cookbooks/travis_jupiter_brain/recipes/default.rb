# frozen_string_literal: true

setup_blue_green = false

remote_file '/usr/local/bin/jb-server' do
  source format(
    node['travis_jupiter_brain']['base_url'],
    node['travis_jupiter_brain']['version']
  )
  checksum node['travis_jupiter_brain']['checksum']
  owner 'root'
  group 'root'
  mode 0o755
end

Array(node['travis_jupiter_brain']['instances']).each do |instance|
  setup_blue_green = true if instance['blue_green']

  template "/etc/init/#{instance['service_name']}.conf" do
    source 'upstart.conf.erb'
    owner 'root'
    group 'root'
    mode 0o644
    variables instance
  end

  template "/etc/default/#{instance['service_name']}" do
    source 'etc-default.erb'
    owner 'root'
    group 'root'
    mode 0o644
    variables instance
  end

  %w[blue green].each do |color|
    file "/etc/default/#{instance['service_name']}-#{color}" do
      content "# Managed by Chef\nexport JUPITER_BRAIN_ADDR='#{instance["#{color}_addr"]}'\n"
      owner 'root'
      group 'root'
      mode 0o644
      only_if { instance['blue_green'] && instance["#{color}_addr"] }
    end
  end

  haproxy_lb instance['service_name'] do
    type 'frontend'
    params(
      'maxconn' => 200,
      'bind' => instance['frontend_bind'],
      'default_backend' => "servers-#{instance['service_name']}"
    )

    only_if { instance['blue_green'] && instance['frontend_bind'] }
  end

  backend_servers = %w[blue green].map do |color|
    addr = instance["#{color}_addr"]
    addr = "127.0.0.1#{addr}" if addr =~ /^:/
    "#{color} #{addr} weight 1 maxconn 100 check"
  end

  haproxy_lb "servers-#{instance['service_name']}" do
    type 'backend'
    mode 'http'
    servers backend_servers

    only_if { instance['blue_green'] && instance['blue_addr'] && instance['green_addr'] }
  end
end

include_recipe 'haproxy::default' if setup_blue_green
include_recipe 'haproxy::install_package' if setup_blue_green
