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

bash 'install git-lfs' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    curl -sLo - https://github.com/github/git-lfs/releases/download/v#{node['travis_build_environment']['git_lfs_version']}/git-lfs-linux-amd64-#{node['travis_build_environment']['git_lfs_version']}.tar.gz | tar xzvf -
    cd git-lfs-*
    ./install.sh
  EOF
  action :run
end
