default['mongodb']['apt_package'] = 'mongodb-org'
if node['lsb']['codename'] == 'precise'
  default['mongodb']['apt_package'] = 'mongodb-10gen'
end
