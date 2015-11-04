apt_repository 'hhvm-repository' do
  uri 'http://dl.hhvm.com/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  key 'http://dl.hhvm.com/conf/hhvm.gpg.key'
end

package node['hhvm']['package']['name'] do
  version node['hhvm']['package']['version']
  options '--force-yes'
  action :install
end
