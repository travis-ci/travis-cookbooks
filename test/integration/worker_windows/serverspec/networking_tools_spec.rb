require_relative 'spec_helper'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe "Networking Tools" do
  skip "PowerShell"
  describe "OpenSSL" do
    describe command('openssl version') do
      its(:stdout) { should match(/OpenSSL \d+\.\d+\.\d+/) }
    end
  end
end