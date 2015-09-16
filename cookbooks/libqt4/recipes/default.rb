case node[:platform]
when "debian", "ubuntu"
  package %w(libqt4-dev qt4-qmake)
end
