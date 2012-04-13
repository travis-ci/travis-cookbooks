users = if Chef::Config[:solo]
          node[:users]
        else
          search(:users)
        end

groups = if Chef::Config[:solo]
           node[:groups]
         else
           search(:groups)
         end

node[:users] = users
node[:groups] = groups

ohai "reload_passwd" do
  action :nothing
  plugin "passwd"
end

groups.each do |group|
  group group[:id] do
    gid group[:gid]
    action [:create, :manage, :modify]
  end
end

users.each do |user|
  primary_group = user[:groups].nil? ? nil : user[:groups].first

  directory File.dirname(user[:home]) do
    action :create
    recursive true
    owner "root"
    group "root"
  end

  user user[:id] do
    shell user[:shell] || "/bin/bash"
    home user[:home]
    gid primary_group
    uid user[:uid]
    supports :manage_home => true
    action [:create, :manage]
    notifies :reload, resources(:ohai => "reload_passwd"), :immediately
  end

  (user[:groups] || []).each do |group_name|
    group_id = groups.find {|group| group[:id] == group_name}[:gid]

    group group_name do
      members [user[:id]]
      gid group_id
      append true
      action [:create, :manage, :modify]
    end
  end

  if user[:ssh_key]
    directory "#{user[:home]}/.ssh" do
      mode "0700"
      owner user[:id]
      group primary_group
      action :create
    end

    template "#{user[:home]}/.ssh/authorized_keys" do
      mode "0600"
      owner user[:id]
      group primary_group
      source "authorized_keys.pub"
      variables :ssh_key => user[:ssh_key]
    end
  end
end
