case node[:platform]
when "ubuntu", "debian"
  package ['libtool', 'libyaml-0-2', 'libyaml-dev']
end
