# opsmatic::agent
#   Installs and configures the Opsmatic agent

include_recipe "opsmatic::common"

if node[:opsmatic][:integration_token].nil? || node[:opsmatic][:integration_token].empty?
  raise "You need to configure your Opsmatic integration_token attribute to install the Opsmatic Agent"
end

# wire up the appropriate repositories
case node[:platform_family] 
when "debian"
  include_recipe "opsmatic::debian_public"
when "rhel"
  include_recipe "opsmatic::rhel_public"
else
  warn "Unfortunately the Opsmatic Agent isn't supported on this platform"
  return
end

# install the opsmatic agent
package "opsmatic-agent" do
  action node[:opsmatic][:agent_action]
  version node[:opsmatic][:agent_version]
end

# perform initial configuration
execute "opsmatic-agent initial configuration" do
  command "/usr/bin/config-opsmatic-agent"
  not_if { ::File.exists?("/var/db/opsmatic-agent/data")}
end

# configure the service
service "opsmatic-agent" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end
