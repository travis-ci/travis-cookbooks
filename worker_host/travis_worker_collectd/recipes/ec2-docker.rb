include_recipe "collectd"

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
