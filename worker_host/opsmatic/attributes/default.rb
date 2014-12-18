# unfortunately "action :upgrade" doesn't seem to work correctly for Gems
# so we'll need to pin the version in the attributes, and suggest
# customers configure this attribute globally in their environment to make
# upgrading easier
default[:opsmatic][:handler_version] = "0.0.14"
# this should only be override or changed on advice from Opsmatic support
default[:opsmatic][:handler_endpoint] = "https://api.opsmatic.com/webhooks/events/chef"
# TODO: we need to work out a portable way to consistently verify certs
# in the meantime we're disabling SSL peer verification by default. You can
# check to see if your chef-client supports peer verify by setting this 
# attribute to true, and if you don't get a warning you're good to go
default[:opsmatic][:handler_ssl_peer_verify] = false

# default to installing the latest version, but don't auto upgrade moving forward
# change action to "upgrade" to automatically fetch the latest version of the agent
# change version to a particular version to pin the agent to a particular version
default[:opsmatic][:agent_action] = "install"
default[:opsmatic][:agent_version] = nil

default[:opsmatic][:integration_token] = nil
default[:opsmatic][:api_http] = nil

# same as corresponding settings for agent, but for the CLI util
default[:opsmatic][:cli_action] = "install"
default[:opsmatic][:cli_version] = nil

