apt_repository "boost-backports" do
  uri          "http://ppa.launchpad.net/mapnik/boost/ubuntu"
  distribution node["lsb"]["codename"]
  components   ["main"]
  keyserver    "hkp://ha.pool.sks-keyservers.net"
  key          "5D50B6BA"
  action       :add
end

apt_repository "hhvm-repository" do
  uri          "http://dl.hhvm.com/ubuntu"
  distribution node["lsb"]["codename"]
  components   ["main"]
  key          "http://dl.hhvm.com/conf/hhvm.gpg.key"
  action       :add
  not_if { node['hhvm']['package']['disabled'] }
end

execute "add-hhvm-manually" do
  command "echo deb http://dl.hhvm.com/ubuntu precise main | sudo tee /etc/apt/sources.list.d/hhvm.list"
end

execute "apt-get-update-hhvm" do
  command "apt-get update"
end

package node["hhvm"]["package"]["name"] do
  action  :install
  options "--allow-change-held-packages --allow-downgrades"
  not_if { node['hhvm']['package']['disabled'] }
end
