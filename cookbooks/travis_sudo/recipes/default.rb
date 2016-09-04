package 'sudo' do
  action [:install, :upgrade]
end

template '/etc/sudoers' do
  source 'sudoers.erb'
  owner 'root'
  group 'root'
  mode 0o440
end

directory '/etc/sudoers.d' do
  owner 'root'
  group 'root'
  mode 0o750
end

node['travis_sudo']['groups'].each do |group|
  file "/etc/sudoers.d/90-group-#{group}" do
    content <<-EOF.gsub(/^\s+> /, '')
      > # Managed by Chef on #{node.name}, thanks! <3 <3 <3
      > # Members of the group #{group.inspect} may gain root privileges, woop!
      > %#{group} ALL=(ALL) ALL
    EOF
    owner 'root'
    group 'root'
    mode 0o440
  end
end
