node[:mounts].each do |mount|
  directory mount[:mount_point] do
    owner "root"
    group "root"
    action :create
    mode "0755"
    recursive true
  end

  mount mount[:mount_point] do
    fstype mount[:filesystem]
    device mount[:device]
    action [:mount, :enable]
  end
end
