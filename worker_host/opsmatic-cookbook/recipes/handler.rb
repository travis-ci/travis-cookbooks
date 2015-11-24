# opsmatic::handler
#   Installs and configures the Opsmatic report and exception handler

include_recipe "opsmatic::common"

chef_gem "chef-handler-opsmatic" do
  action :upgrade
  version node[:opsmatic][:handler_version]
end

require 'chef/handler/opsmatic'

chef_handler "Chef::Handler::Opsmatic" do
  source "chef/handler/opsmatic"
  arguments [ 
    :integration_token => node[:opsmatic][:integration_token],
    :collector_url     => node[:opsmatic][:handler_endpoint],
    :ssl_peer_verify   => node[:opsmatic][:handler_ssl_peer_verify]
  ]
  action :nothing
end.run_action(:enable)
