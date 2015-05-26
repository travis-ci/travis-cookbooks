default['apt']['mirror'] = :us
default['apt']['python_software_properties_package'] = 'python-software-properties'
if node['lsb']['codename'] == 'trusty'
  default['apt']['python_software_properties_package'] = 'python3-software-properties'
end
