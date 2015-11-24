include_recipe 'collectd'

collectd_plugin "load"

collectd_plugin "memory"

collectd_plugin "interface" do
  options :interface => "lo", :ignore_selected => true
end

collectd_plugin "df" do
  options :mount_point => "/",
          :report_reserved => false,
          :report_inodes => false
end
