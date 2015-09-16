
apt_repository "openjdk-r-java-ppa" do
  uri          "http://ppa.launchpad.net/openjdk-r/ppa/ubuntu"
  distribution node['lsb']['codename']
  components   ["main"]
  key          "86F44E2A"
  keyserver    "keyserver.ubuntu.com"

  action :add
end

