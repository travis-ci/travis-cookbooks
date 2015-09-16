# opsmatic::cli
#   Installs and configures opsmatic CLI utils

include_recipe 'opsmatic::common'

# wire up the appropriate repositories
if node['opsmatic']['public_repo']
  case node['platform_family']
  when 'debian'
    include_recipe 'opsmatic::debian_public'
  when 'rhel'
    include_recipe 'opsmatic::rhel_public'
  else
    warn 'Unfortunately the Opsmatic CLI isn\'t supported on this platform'
    return
  end
end

# install the opsmatic CLI utility
package 'opsmatic-cli' do
  action node['opsmatic']['cli_action']
  version node['opsmatic']['cli_version']
end
