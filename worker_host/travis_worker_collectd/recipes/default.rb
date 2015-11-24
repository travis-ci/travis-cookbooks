include_recipe 'collectd'

collectd_plugin "load"

collectd_plugin "memory"

collectd_plugin "cpu"

collectd_plugin "interface" do
  options :interface => "lo", :ignore_selected => true
end

