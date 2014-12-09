include_recipe "collectd"

collectd_plugin "load"

collectd_plugin "memory"

collectd_plugin "interface" do
  options :interface => %w[eth0 docker0]
end

%w[/ /mnt /data/travis].each do |mount_point|
  collectd_plugin "df" do
    options :mount_point => mount_point,
            :report_reserved => false,
            :report_inodes => false,
            :values_percentage => true
  end
end
