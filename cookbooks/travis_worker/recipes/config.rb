# frozen_string_literal: true

%w[
  /etc/default/travis-worker
  /etc/default/travis-worker-chef
].each do |filename|
  template filename do
    source 'etc-default-travis-worker.sh.erb'
    owner 'root'
    group 'root'
    mode 0o644
    variables(environment: node['travis_worker']['environment'])

    not_if { node['travis_worker']['disable_reconfiguration'] }
  end
end
