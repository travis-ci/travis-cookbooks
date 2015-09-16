include_recipe "collectd"

collectd_plugin "syslog" do
  options :log_level => "info",
          :notify_level => "OKAY"
end

collectd_plugin "load"

collectd_plugin "memory"

collectd_plugin "interface" do
  options :interface => %w[eth0 docker0]
end

collectd_plugin "df" do
  options :mount_point => %w[/ /mnt /data/travis],
          :report_reserved => false,
          :report_inodes => false,
          :values_percentage => true
end

cookbook_file "#{node[:collectd][:plugin_dir]}/docker_lvm.py" do
  source "docker_lvm.py"
  owner "root"
  group "root"
  mode 0644
end

collectd_plugin "docker_lvm" do
  options paths: [node[:collectd][:plugin_dir]],
          modules: { docker_lvm: {} }
  template "python_plugin.conf.erb"
  cookbook "collectd"
end
