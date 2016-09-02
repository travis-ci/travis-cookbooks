template '/etc/default/travis-worker' do
  source 'travis-worker.erb'
  owner 'root'
  group 'root'
  mode 0o644
  variables(environment: node['travis']['worker']['environment'])

  not_if { node['travis']['worker']['disable_reconfiguration'] }
end
