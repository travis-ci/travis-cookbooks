apt_repository "hhvm-repository" do
  uri          "http://dl.hhvm.com/ubuntu"
  distribution node["lsb"]["codename"]
  components   ["main"]
  key          "http://dl.hhvm.com/conf/hhvm.gpg.key"
  action :add
end

package node["hhvm"]["package"]["name"] do
  action  :install
  version node["hhvm"]["package"]["version"]
  options "--force-yes"
end

cookbook_file "/etc/hhvm/php.ini" do
  owner "root"
  group "root"
  mode 0644
end