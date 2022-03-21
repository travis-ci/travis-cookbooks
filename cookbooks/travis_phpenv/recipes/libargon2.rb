# frozen_string_literal: true

git "#{Chef::Config[:file_cache_path]}/libargon2" do
  repository "https://github.com/P-H-C/phc-winner-argon2.git"
  action :sync
end

bash 'install libargon2' do
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  cwd "#{Chef::Config[:file_cache_path]}/libargon2"
  code <<-INSTALL
    LIBARGON2_INSTALL_DIR=$HOME/.phpenv/versions/$VERSION
    make test
    sudo make install PREFIX=/usr
  INSTALL
end
