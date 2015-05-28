case node[:platform]
when "debian", "ubuntu"
  package ['libqt4-dev', 'qt4-qmake']
end
