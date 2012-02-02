case node[:platform]
when "debian", "ubuntu"
  package "libqt4-dev"
  package "qt4-qmake"
end
