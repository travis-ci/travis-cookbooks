# frozen_string_literal: true

gpg_keys = {
  mpapis: '08f64631c598cbe4398c5850725c8e6ab60dc5d86b6214e069d7ced1d546043b',
  pkuczynski: 'd33ce5907fe28e6938feab7f63a9ef8a26a565878b1ad5bce063a86019aeaf77'
}

def gpg_key_path(name)
  ::File.join(
    Chef::Config[:file_cache_path], "#{name}.asc"
  )
end

rvm_installer_path = ::File.join(
  Chef::Config[:file_cache_path], 'rvm-installer'
)
rvmrc_path = ::File.join(
  node['travis_build_environment']['home'], '.rvmrc'
)
rvmrc_content = Array(
  node['travis_build_environment']['rvmrc_env']
).map { |k, v| "#{k}='#{v}'" }.join("\n")
rvm_script_path = ::File.join(
  node['travis_build_environment']['home'], '.rvm', 'bin', 'rvm'
)
global_gems = Array(
  node['travis_build_environment']['global_gems']
).map { |g| g[:name] }.join(' ')

package %w[
  automake
  bash
  bison
  bzip2
  curl
  g++
  gawk
  gcc
  gnupg2
  libc6-dev
  libffi-dev
  libgdbm-dev
  libgmp-dev
  libncurses5-dev
  libreadline6-dev
  libsqlite3-dev
  libssl-dev
  libtool
  libyaml-dev
  make
  openssl
  patch
  pkg-config
  sqlite3
  zlib1g
  zlib1g-dev
] do
  action :install
  options '--no-install-recommends --no-upgrade'
end

gpg_keys.each do |name, checksum|
  key_path = gpg_key_path(name)

  remote_file key_path do
    source "https://rvm.io/#{name}.asc"
    checksum checksum
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    mode 0o644
    retries 2
    retry_delay 30
  end

  bash "import #{name}.asc" do
    code "gpg2 --import #{key_path}"
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment('HOME' => node['travis_build_environment']['home'])
    only_if { ::File.exist?(key_path) }
  end
end

remote_file rvm_installer_path do
  source 'https://get.rvm.io'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
  retries 2
  retry_delay 30
end

file rvmrc_path do
  content rvmrc_content
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o644
end

bash 'run rvm installer' do
  code "#{rvm_installer_path} stable"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  creates ::File.join(
    node['travis_build_environment']['home'],
    '.rvm', 'VERSION'
  )
  environment('HOME' => node['travis_build_environment']['home'])
  retries 2
  retry_delay 30
end

install_flag = "--autolibs=disable --binary --fuzzy"
if node['kernel']['machine'] == "ppc64le"
  install_flag = "--autolibs=disable --fuzzy"
end

bash "install default ruby #{node['travis_build_environment']['default_ruby']}" do
  code %W[
    #{rvm_script_path} install
    #{node['travis_build_environment']['default_ruby']}
    #{install_flag}
  ].join(' ')
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment('HOME' => node['travis_build_environment']['home'])
  not_if { node['travis_build_environment']['default_ruby'].to_s.empty? }
  retries 2
  retry_delay 30
end

bash "create default alias for #{node['travis_build_environment']['default_ruby']}" do
  code %W[
    #{rvm_script_path} alias create
    default #{node['travis_build_environment']['default_ruby']}
  ].join(' ')
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment('HOME' => node['travis_build_environment']['home'])
  not_if { node['travis_build_environment']['default_ruby'].to_s.empty? }
end

bash 'install global gems' do
  code "#{rvm_script_path} @global do gem install #{global_gems}"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment('HOME' => node['travis_build_environment']['home'])
  retries 2
  retry_delay 30
end

Array(node['travis_build_environment']['rubies']).each do |ruby_def|
  next if ruby_def == node['travis_build_environment']['default_ruby']

  bash "install ruby #{ruby_def}" do
    code %W[
      #{rvm_script_path} install
      #{ruby_def} #{install_flag}
    ].join(' ')
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment('HOME' => node['travis_build_environment']['home'])
    retries 2
    retry_delay 30
  end
end
