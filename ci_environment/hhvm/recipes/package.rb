apt_repository "hhvm-repository" do
  uri          "http://dl.hhvm.com/ubuntu"
  distribution node["lsb"]["codename"]
  components   ["main"]

  action :add
end

package "hhvm" do
  action  :install
  version node["hhvm"]["package"]["version"]
  options "--force-yes"
end
