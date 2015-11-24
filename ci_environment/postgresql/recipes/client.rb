include_recipe 'postgresql::pgdg'

#
# Install PostgreSQL Clients
#
node['postgresql']['client_packages'].each do |p|
  package p
end

