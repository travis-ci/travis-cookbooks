
require 'openssl'
 
w{ ca.crt  ca.tmpl Makefile  server.crt server.tmpl }.each do |file|
  cookbook_file "#{node['mysql']['conf_dir']}/ssl/#{file}" do
    source "etc/mysql/ssl/#{file}"
    owner 'mysql'
    group 'mysql'
    mode 0444
  end
end

w{ ca.key server.key }.each do |file|
  cookbook_file "#{node['mysql']['conf_dir']}/ssl/#{file}" do
    source "etc/mysql/ssl/#{file}"
    owner 'mysql'
    group 'mysql'
    mode 0440
  end
end

w{client.crt  client.key  client.tmpl }.each do |file|
  cookbook_file "#{node['mysql']['conf_dir']}/ssl/#{file}" do
    source "etc/mysql/ssl/#{file}"
    owner 'root'
    group 'root'
    mode 0644
  end
end

cookbook_file "#{node['mysql']['conf_dir']}/conf.d/ssl.cnf" do
  source "etc/mysql/ssl/ssl.cnf"
  owner 'root'
  group 'root'
  mode 0444
  notifies :restart, "service[mysql]"
end

raw = File.read "#{node['mysql']['conf_dir']}/ssl/client.crt"
client_certificate = OpenSSL::X509::Certificate.new raw

# client_certificate is used in grants.sql.erb later
