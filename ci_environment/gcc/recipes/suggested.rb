
if node['gcc']['ppa']['install_suggested_packages']
  %w(automake bison flex libtool).each do |p|
    package p
  end
end

