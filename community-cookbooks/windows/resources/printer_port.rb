#
# Author:: Doug Ireton (<doug.ireton@nordstrom.com>)
# Cookbook:: windows
# Resource:: printer_port
#
# Copyright:: 2012-2017, Nordstrom, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# See here for more info:
# http://msdn.microsoft.com/en-us/library/windows/desktop/aa394492(v=vs.85).aspx

require 'resolv'

property :ipv4_address, String, name_property: true, required: true, regex: Resolv::IPv4::Regex
property :port_name, String
property :port_number, Integer, default: 9100
property :port_description, String
property :snmp_enabled, [true, false], default: false
property :port_protocol, Integer, default: 1, equal_to: [1, 2]
property :exists, [true, false]

PORTS_REG_KEY = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Monitors\Standard TCP/IP Port\Ports\\'.freeze unless defined?(PORTS_REG_KEY)

def port_exists?(name)
  port_reg_key = PORTS_REG_KEY + name

  Chef::Log.debug "Checking to see if this reg key exists: '#{port_reg_key}'"
  Registry.key_exists?(port_reg_key)
end

load_current_value do |desired|
  name desired.name
  ipv4_address desired.ipv4_address
  port_name desired.port_name || "IP_#{@new_resource.ipv4_address}"
  exists port_exists?(desired.port_name)
  # TODO: Set @current_resource port properties from registry
end

action :create do
  if current_resource.exists
    Chef::Log.info "#{@new_resource} already exists - nothing to do."
  else
    converge_by("Create #{@new_resource}") do
      create_printer_port
    end
  end
end

action :delete do
  if current_resource.exists
    converge_by("Delete #{@new_resource}") do
      delete_printer_port
    end
  else
    Chef::Log.info "#{@current_resource} doesn't exist - can't delete."
  end
end

action_class do
  def create_printer_port
    port_name = new_resource.port_name || "IP_#{new_resource.ipv4_address}"

    # create the printer port using PowerShell
    powershell_script "Creating printer port #{new_resource.port_name}" do
      code <<-EOH

        Set-WmiInstance -class Win32_TCPIPPrinterPort `
          -EnableAllPrivileges `
          -Argument @{ HostAddress = "#{new_resource.ipv4_address}";
                      Name        = "#{port_name}";
                      Description = "#{new_resource.port_description}";
                      PortNumber  = "#{new_resource.port_number}";
                      Protocol    = "#{new_resource.port_protocol}";
                      SNMPEnabled = "$#{new_resource.snmp_enabled}";
                    }
      EOH
    end
  end

  def delete_printer_port
    port_name = new_resource.port_name || "IP_#{new_resource.ipv4_address}"

    powershell_script "Deleting printer port: #{new_resource.port_name}" do
      code <<-EOH
        $port = Get-WMIObject -class Win32_TCPIPPrinterPort -EnableAllPrivileges -Filter "name = '#{port_name}'"
        $port.Delete()
      EOH
    end
  end
end
