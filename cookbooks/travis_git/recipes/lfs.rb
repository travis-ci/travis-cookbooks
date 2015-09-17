bash 'install git-lfs' do
  cwd Chef::Config[:file_cache_path]

  code <<-EOF
    curl -sLo - https://github.com/github/git-lfs/releases/download/v#{node.git.lfs.version}/git-lfs-linux-amd64-#{node.git.lfs.version}.tar.gz | tar xzvf -
    cd git-lfs-*
    ./install.sh
  EOF

  action :run
end