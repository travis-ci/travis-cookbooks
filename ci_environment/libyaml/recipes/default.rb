case node[:platform]
when "ubuntu", "debian"
  package "libyaml-0-2"
  package "libyaml-dev"
end
