case node[:platform]
when "ubuntu", "debian"
  package "libtool"
  package "libyaml-0-2"
  package "libyaml-dev"
end
