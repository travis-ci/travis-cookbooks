include_recipe 'postgresql::pgdg'

#
# Install PostgreSQL Clients
#
unless node['postgresql']['client_packages'].empty?
  package node['postgresql']['client_packages']
end
