directory node[:ramfs][:dir] do
  owner  "root"
  group  "root"
  mode   "0755"
  action :create
end

mount node[:ramfs][:dir] do
  fstype   "tmpfs"
  device   "/dev/null" # http://tickets.opscode.com/browse/CHEF-1657
  options  "defaults,size=#{node[:ramfs][:size]},noatime"
  action   [:mount, :enable]
end
