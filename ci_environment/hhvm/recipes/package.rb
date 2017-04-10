apt_repository "boost-backports" do
  uri          "http://ppa.launchpad.net/mapnik/boost/ubuntu"
  distribution node["lsb"]["codename"]
  components   ["main"]
  keyserver    "hkp://ha.pool.sks-keyservers.net"
  key          "5D50B6BA"
  action       :add
end

package Array(node['libboost-filesystem1.49.0', 'libboost-program-options1.49.0', 'libboost-regex1.49.0', 'libboost-system1.49.0', 'libboost-thread1.49.0', 'libgd2-xpm', 'libonig2', 'libtbb2', 'libunwind7']['package']['name']) do
  action :install
end

apt_repository "boost-backports" do
  action       :remove
end

apt_repository "hhvm-repository" do
  uri          "http://dl.hhvm.com/ubuntu"
  distribution node["lsb"]["codename"]
  components   ["main"]
  key          "http://dl.hhvm.com/conf/hhvm.gpg.key"
  action       :add
  not_if { node['hhvm']['package']['disabled'] }
end

package node["hhvm"]["package"]["name"] do
  action  :install
  options "--allow-change-held-packages --allow-downgrades"
  not_if { node['hhvm']['package']['disabled'] }
end
