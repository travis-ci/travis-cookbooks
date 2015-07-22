default['apt']['mirror'] = :us
default['apt']['python_software_properties_package'] = 'python3-software-properties'
if node['lsb']['codename'] == 'precise'
  default['apt']['python_software_properties_package'] = 'python-software-properties'
end
