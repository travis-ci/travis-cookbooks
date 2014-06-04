require 'rspec/its'
require 'serverspec'
require 'winrm'

include SpecInfra::Helper::WinRM
include SpecInfra::Helper::Windows

RSpec.configure do |c|
  user = 'vagrant'
  pass = 'vagrant'
  endpoint = "http://localhost:5985/wsman"

  c.winrm = ::WinRM::WinRMWebService.new(endpoint, :ssl, :user => user, :pass => pass, :basic_auth_only => true)
  c.winrm.set_timeout 300 # 5 minutes max timeout for any operation
end
