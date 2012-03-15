node[:mounts].each do |device, (filesystem, mount_point)|
  mount mount_point do
    fstype filesystem
    device device
    action [:mount, :enable]
  end
end
