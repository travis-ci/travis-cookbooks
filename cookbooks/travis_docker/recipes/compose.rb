remote_file '/usr/local/bin/docker-compose' do
  source node['travis_docker']['compose']['url']
  checksum node['travis_docker']['compose']['sha256sum']
  owner 'root'
  group 'root'
  mode 0755
end
