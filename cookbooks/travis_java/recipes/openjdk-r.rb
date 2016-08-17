apt_repository 'openjdk-r-java-ppa' do
  uri 'http://ppa.launchpad.net/openjdk-r/ppa/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  key '86F44E2A'
  keyserver 'pgp.mit.edu'
  retries 2
  retry_delay 30
  action :add
end
