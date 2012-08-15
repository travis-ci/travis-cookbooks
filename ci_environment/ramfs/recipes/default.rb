directory node[:ramfs][:dir] do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

mount node[:ramfs][:dir] do
  fstype   "tmpfs"
  device   "/dev/null" # http://tickets.opscode.com/browse/CHEF-1657
  options  "defaults,size=256m,noatime"
  action   [:mount, :enable]
end

case [node[:platform], node[:platform_version]]
# wipe out apparmor on 11.04, it won't let mysqld to start from /var/ramfs with default policies. MK.
when ["ubuntu", "11.04"] then
  package "apparmor" do
    action :remove
  end

  package "apparmor-utils" do
    action :remove
  end
end

1
