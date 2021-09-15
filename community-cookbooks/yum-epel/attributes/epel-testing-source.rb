default['yum']['epel-testing-source']['repositoryid'] = 'epel-testing-source'
default['yum']['epel-testing-source']['description'] = "Extra Packages for #{node['platform_version'].to_i} - $basearch - Testing Source"
if platform?('amazon')
  default['yum']['epel-testing-source']['mirrorlist'] = 'http://mirrors.fedoraproject.org/mirrorlist?repo=testing-source-epel6&arch=$basearch'
  default['yum']['epel-testing-source']['gpgkey'] = 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
else
  default['yum']['epel-testing-source']['mirrorlist'] = "http://mirrors.fedoraproject.org/mirrorlist?repo=testing-source-epel#{node['platform_version'].to_i}&arch=$basearch"
  default['yum']['epel-testing-source']['gpgkey'] = "https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-#{node['platform_version'].to_i}"
end
default['yum']['epel-testing-source']['failovermethod'] = 'priority'
default['yum']['epel-testing-source']['gpgcheck'] = true
default['yum']['epel-testing-source']['enabled'] = false
default['yum']['epel-testing-source']['managed'] = false
default['yum']['epel-testing-source']['make_cache'] = true
