template "/etc/default/docker.chef" do
  source "etc-default-docker.chef.sh.erb"
  owner "root"
  group "root"
  mode 0644
end

template "/etc/default/docker" do
  source "etc-default-docker.sh.erb"
  owner "root"
  group "root"
  mode 0644
end

template "/etc/init/docker.conf" do
  source "etc-init-docker.conf.erb"
  owner "root"
  group "root"
  mode 0644
end
