default['yum']['epel-source']['repositoryid'] = 'epel-source'
default['yum']['epel-source']['description'] = "Extra Packages for #{node['platform_version'].to_i} - $basearch - Source"
if platform?('amazon')
  default['yum']['epel-source']['mirrorlist'] = 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-source-6&arch=$basearch'
  default['yum']['epel-source']['gpgkey'] = 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
else
  default['yum']['epel-source']['mirrorlist'] = "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-source-#{node['platform_version'].to_i}&arch=$basearch"
  default['yum']['epel-source']['gpgkey'] = "https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-#{node['platform_version'].to_i}"
end
default['yum']['epel-source']['failovermethod'] = 'priority'
default['yum']['epel-source']['gpgcheck'] = true
default['yum']['epel-source']['enabled'] = false
default['yum']['epel-source']['managed'] = false
default['yum']['epel-source']['make_cache'] = true
