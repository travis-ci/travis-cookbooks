case node[:platform]
when 'ubuntu', 'debian'
  package %w(libtool libyaml-0-2 libyaml-dev)
end
