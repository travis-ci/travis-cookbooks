require 'uri'

uri = URI.parse(node['hhvm']['package']['url'])
filename = File.basename(uri.path)
package_path = "#{Chef::Config[:file_cache_path]}/#{filename}"

package %w(libtcmalloc-minimal0 libboost-thread1.48.0 libunwind7)

remote_file package_path do
  source node['hhvm']['package']['url']
  owner  node['travis_build_environment']['user']
  group  node['travis_build_environment']['group']
end

package package_path do
  ignore_failure true
  action :install
  source "#{Chef::Config[:file_cache_path]}/hhvm_2.3.0_amd64.deb"
  provider Chef::Provider::Package::Dpkg
end

bash 'install package dependencies' do
  user 'root'
  code 'apt-get -yf install'
end
