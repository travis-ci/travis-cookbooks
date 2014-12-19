#
# Cookbook Name:: duo_unix
# Recipe:: default
#

case node[:platform]
when "ubuntu"
  package "libssl-dev" do
    action :upgrade
  end

  package "libpam-dev" do
    action :upgrade
  end
else
  warn "unsupported platform"
  return
end

apt_repository "duosecurity" do
  uri "http://pkg.duosecurity.com/Ubuntu"
  distribution "trusty"
  components ["main"]
  key "duosecurity.gpg"
end

package "duo-unix" do
  action :upgrade
end

template "/etc/duo/login_duo.conf" do
  source "login_duo.conf.erb"
  owner node["duo_unix"]["user"]
  group node["duo_unix"]["group"] || node["duo_unix"]["user"]
  mode "00600"
end
