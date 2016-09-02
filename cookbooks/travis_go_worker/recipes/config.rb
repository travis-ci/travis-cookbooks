%w(
  /etc/default/travis-worker
  /etc/default/travis-worker-chef
).each do |filename|
  template filename do
    source 'travis-worker.erb'
    owner 'root'
    group 'root'
    mode 0o644
    variables(environment: node['travis_go_worker']['environment'])

    not_if { node['travis_go_worker']['disable_reconfiguration'] }
  end
end
