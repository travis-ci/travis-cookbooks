require "tmpdir"
require "uri"

tmpdir       = Dir.tmpdir
uri          = URI.parse(node["riak"]["package"]["url"])
filename     = File.basename(uri.path)
package_path = "#{tmpdir}/#{filename}"

remote_file package_path do
  source node["riak"]["package"]["url"]
  owner  node["travis_build_environment"]["user"]
  group  node["travis_build_environment"]["group"]
end

package package_path do
  ignore_failure true
  action         :install
  source         "#{Dir.tmpdir}/riak_2.0.0rc1-1_amd64.deb"
  provider       Chef::Provider::Package::Dpkg
end

bash "install package dependencies" do
  user  "root"
  code  "apt-get -yf install"
end
