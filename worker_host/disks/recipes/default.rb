node[:mounts].each do |mount|
  mount mount[:mount_point] do
    fstype mount[:filesystem]
    device mount[:device]
    action [:mount, :enable]
  end
end
