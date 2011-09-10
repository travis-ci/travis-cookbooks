case node['platform']
when "ubuntu"
  apt_repository "kubuntu-backports-ppa-deb" do
    uri          "http://ppa.launchpad.net/kubuntu-ppa/backports/ubuntu"
    distribution node['lsb']['codename']
    components   ['main']
    key          "https://raw.github.com/gist/1208649/51c907099ec6f2003c6e120621f069c3cd1a75e6/gistfile1.txt"
    action       :add
  end

  # this LWRP seems to ONLY install deb-src repo if deb_src attribute is set,
  # so we pretty much duplicate this resource to work around that. MK.
  apt_repository "kubuntu-backports-ppa-deb-src" do
    uri          "http://ppa.launchpad.net/kubuntu-ppa/backports/ubuntu"
    distribution node['lsb']['codename']
    components   ['main']
    deb_src      true
    key          "https://raw.github.com/gist/1208649/51c907099ec6f2003c6e120621f069c3cd1a75e6/gistfile1.txt"
    action       :add
  end
end

case node[:platform]
when "debian", "ubuntu"
  package "libqt4-dev"
  package "qt4-qmake"
end