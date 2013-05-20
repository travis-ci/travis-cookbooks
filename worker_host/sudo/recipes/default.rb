include_recipe 'users'

package "sudo" do
  action :upgrade
end

template "/etc/sudoers" do
  source "sudoers.erb"
  mode 0440
  owner "root"
  group "root"
  variables :groups => node[:sudo][:groups],
            :users => node[:sudo][:users]
end
