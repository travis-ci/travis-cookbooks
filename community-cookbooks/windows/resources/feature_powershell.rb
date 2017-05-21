#
# Author:: Greg Zapp (<greg.zapp@gmail.com>)
# Cookbook:: windows
# Provider:: feature_powershell
#

property :feature_name, [Array, String], name_attribute: true
property :source, String
property :all, [true, false], default: false

include Chef::Mixin::PowershellOut
include Windows::Helper

action :remove do
  if installed?
    converge_by("remove Windows feature #{new_resource.feature_name}") do
      cmd = powershell_out!("#{remove_feature_cmdlet} #{to_array(new_resource.feature_name).join(',')}")
      Chef::Log.info(cmd.stdout)
    end
  end
end

action :delete do
  if available?
    converge_by("delete Windows feature #{new_resource.feature_name} from the image") do
      cmd = powershell_out!("Uninstall-WindowsFeature #{to_array(new_resource.feature_name).join(',')} -Remove")
      Chef::Log.info(cmd.stdout)
    end
  end
end

action_class.class_eval do
  def install_feature_cmdlet
    node['os_version'].to_f < 6.2 ? 'Import-Module ServerManager; Add-WindowsFeature' : 'Install-WindowsFeature'
  end

  def remove_feature_cmdlet
    node['os_version'].to_f < 6.2 ? 'Import-Module ServerManager; Remove-WindowsFeature' : 'Uninstall-WindowsFeature'
  end

  def installed?
    @installed ||= begin
      cmd = powershell_out("(Get-WindowsFeature #{to_array(new_resource.feature_name).join(',')} | ?{$_.InstallState -ne \'Installed\'}).count")
      cmd.stderr.empty? && cmd.stdout.chomp.to_i == 0
    end
  end

  def available?
    @available ||= begin
      cmd = powershell_out("(Get-WindowsFeature #{to_array(new_resource.feature_name).join(',')} | ?{$_.InstallState -ne \'Removed\'}).count")
      cmd.stderr.empty? && cmd.stdout.chomp.to_i > 0
    end
  end
end

action :install do
  Chef::Log.warn("Requested feature #{new_resource.feature_name} is not available on this system.") unless available?
  unless !available? || installed?
    converge_by("install Windows feature #{new_resource.feature_name}") do
      addsource = new_resource.source ? "-Source \"#{new_resource.source}\"" : ''
      addall = new_resource.all ? '-IncludeAllSubFeature' : ''
      cmd = if node['os_version'].to_f < 6.2
              powershell_out!("#{install_feature_cmdlet} #{to_array(new_resource.feature_name).join(',')} #{addall}")
            else
              powershell_out!("#{install_feature_cmdlet} #{to_array(new_resource.feature_name).join(',')} #{addsource} #{addall}")
            end
      Chef::Log.info(cmd.stdout)
    end
  end
end
