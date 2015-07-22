if node['gcc']['ppa']['install_suggested_packages']
  package %w(automake bison flex libtool)
end
