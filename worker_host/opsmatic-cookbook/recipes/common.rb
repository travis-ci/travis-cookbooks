# stuff that should be included everywhere

template "/etc/default/opsmatic-global" do
  source "default-opsmatic-global.erb"
  owner "root"
  group "root"
  mode "00644"
end
