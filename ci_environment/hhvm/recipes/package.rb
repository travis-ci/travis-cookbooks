if node["lsb"]["codename"] == 'precise'
  apt_repository "boost-backports" do
    uri          "http://ppa.launchpad.net/mapnik/boost/ubuntu"
    distribution node["lsb"]["codename"]
    components   ["main"]
    keyserver    "keyserver.ubuntu.com"
    key          "5D50B6BA"
    action       :add
  end
end

apt_repository "hhvm-repository" do
  uri          "http://dl.hhvm.com/ubuntu"
  distribution node["lsb"]["codename"]
  components   ["main"]
  key          "http://dl.hhvm.com/conf/hhvm.gpg.key"
  action       :add
end

package node["hhvm"]["package"]["name"] do
  action  :install
  version [node["hhvm"]["package"]["version"], node['lsb']['codename']].join('~')
  options "--force-yes"
end
