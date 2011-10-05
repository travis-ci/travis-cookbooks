case node[:platform]
when "ubuntu", "debian"
  package "libossp-uuid-dev"
end
