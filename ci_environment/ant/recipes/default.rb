include_recipe 'java'

case node['platform']
when 'centos', 'redhat', 'fedora'
  include_recipe 'jpackage'
end

package %w(ant ant-contrib ivy)
