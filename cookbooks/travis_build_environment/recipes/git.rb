apt_repository 'git-ppa' do
  uri 'http://ppa.launchpad.net/git-core/ppa/ubuntu'
  distribution node['lsb']['codename']
  components %w(main)
  key 'E1DF1F24'
  keyserver 'hkp://ha.pool.sks-keyservers.net'
  retries 2
  retry_delay 30
end

package 'git' do
  action :upgrade
end

packagecloud_repo 'github/git-lfs' do
  type 'deb'
end
