
case node[:platform]
when "debian", "ubuntu", "redhat", "centos", "fedora"
  package "util-linux"
end
