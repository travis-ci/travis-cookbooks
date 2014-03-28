require 'serverspec'

include SpecInfra::Helper::Exec
include SpecInfra::Helper::DetectOS

RSpec.configure do |c|
  if ENV['ASK_SUDO_PASSWORD']
    require 'highline/import'
    c.sudo_password = ask('Enter sudo password: ') { |q| q.echo = false }
  else
    c.sudo_password = ENV['SUDO_PASSWORD']
  end
end

# Ideally, I'd just use serverspec via ssh (or winrm) as travis
# but currently test-kitchen only supports serverspec running locally.
def command_as_travis(command)
  command("cd /home/travis && su -s /bin/bash -c \"#{command}\" travis")
end
