include_recipe "travis_worker_collectd"

collectd_plugin "df" do
  options :mount_point => "/",
          :report_reserved => false,
          :report_inodes => false
end
