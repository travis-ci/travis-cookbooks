gem_package "httparty" do
end.run_action(:install)

begin
  require 'httparty'
rescue LoadError
  Gem.refresh
end

chef_handler "CampfireHandler" do
  source "#{node['chef_handler']['handler_path']}/campfire_handler.rb"
  arguments :subdomain => node[:campfire][:subdomain],
            :room_id => node[:campfire][:room_id],
            :token => node[:campfire][:token]
end.run_action(:enable)
