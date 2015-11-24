apt_repository 'restricted-universe-multiverse' do
  uri 'http://archive.ubuntu.com/ubuntu'
  distribution node['lsb']['codename']
  components %w(restricted universe multiverse)
  action :add
end
