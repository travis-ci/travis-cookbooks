include_recipe 'users'

package 'sudo' do
  action :upgrade
end

template '/etc/sudoers' do
  source 'sudoers.erb'
  mode 0440
  owner 'root'
  group 'root'
end

directory '/etc/sudoers.d' do
  mode 0750
  owner 'root'
  group 'root'
end

node['sudo']['groups'].each do |group|
  file "/etc/sudoers.d/90-group-#{group}" do
    content <<-EOF.gsub(/^\s+> /, '')
      > # Managed by Chef on #{node.name}, thanks! <3 <3 <3
      > # Members of the group #{group.inspect} may gain root privileges, woop!
      > %#{group} ALL=(ALL) ALL
    EOF
    mode 0440
    owner 'root'
    group 'root'
  end
end

node['sudo']['users'].each do |user|
  file "/etc/sudoers.d/90-user-#{user['name']}" do
    content <<-EOF.gsub(/^\s+> /, '')
      > # Managed by Chef on #{node.name}, thanks! <3 <3 <3
      > # User #{user['name'].inspect} may gain root priveleges, woop!
      > #{user['name']} ALL=(#{user['target_user'] || 'ALL'}) #{user['nopassword'] ? 'NOPASSWD: ' : ''} #{user['command'] || 'ALL'}
    EOF
    mode 0440
    owner 'root'
    group 'root'
  end
end
