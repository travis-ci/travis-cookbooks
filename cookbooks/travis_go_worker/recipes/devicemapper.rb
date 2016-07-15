package %w(
  lvm2
  xfsprogs
)

template '/usr/local/bin/travis-docker-volume-setup' do
  source 'travis-docker-volume-setup.sh.erb'
  owner 'root'
  group 'root'
  mode 0755
  variables(
    device: node['travis']['worker']['docker']['volume']['device'],
    metadata_size: node['travis']['worker']['docker']['volume']['metadata_size']
  )
end
