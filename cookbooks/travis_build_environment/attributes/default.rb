default['travis_build_environment']['user'] = 'travis'
default['travis_build_environment']['group'] = node['travis_build_environment']['user']
default['travis_build_environment']['home'] = "/home/#{node['travis_build_environment']['user']}"
default['travis_build_environment']['user_comment'] = 'Travis CI User'
default['travis_build_environment']['user_email'] = 'travis@example.org'
default['travis_build_environment']['hosts'] = {}
default['travis_build_environment']['update_hosts'] = true
default['travis_build_environment']['update_hostname'] = true
default['travis_build_environment']['builds_volume_size'] = '350m'
default['travis_build_environment']['use_tmpfs_for_builds'] = true
default['travis_build_environment']['installation_suffix'] = 'org'
default['travis_build_environment']['disable_apparmor'] = false
default['travis_build_environment']['apt']['timeout'] = 10
default['travis_build_environment']['apt']['retries'] = 2
default['travis_build_environment']['i18n_supported_file'] = '/usr/share/i18n/SUPPORTED'
default['travis_build_environment']['language_codes'] = %w(
  ar_AE
  ar_EG
  de_AT
  de_BE
  de_CH
  de_DE
  en_AU
  en_GB
  en_US
  es_ES
  es_MX
  fr_BE
  fr_CH
  fr_FR
  he_IL
  hi_IN
  ja_JP
  ko_KR
  ms_MY
  pt_BR
  ru_RU
  ru_UA
  uk_UA
  zh_CN
  zh_TW
).map { |l| "#{l}.UTF-8" }
default['travis_build_environment']['rubies'] = %w(1.9.3-p551 2.2.3)
default['travis_build_environment']['default_ruby'] = '2.2.3'
default['travis_build_environment']['gems'] = {}
default['travis_build_environment']['global_gems'] = %w(
  bundler
  nokogiri
  rake
).map { |gem| { name: gem } }
default['travis_build_environment']['rvm_release'] = 'stable'
default['travis_build_environment']['rvmrc_env'] = {
  'rvm_autoupdate_flag' => '0',
  'rvm_binary_flag' => '1',
  'rvm_fuzzy_flag' => '1',
  'rvm_gem_options' => '--no-ri --no-rdoc',
  'rvm_max_time_flag' => '5',
  'rvm_path' => "#{node['travis_build_environment']['home']}/.rvm",
  'rvm_project_rvmrc' => '0',
  'rvm_remote_server_type4' => 'rubies',
  'rvm_remote_server_url4' => 'https://s3.amazonaws.com/travis-rubies/binaries',
  'rvm_remote_server_verify_downloads4' => '1',
  'rvm_silence_path_mismatch_check_flag' => '1',
  'rvm_user_install_flag' => '1',
  'rvm_with_default_gems' => 'rake bundler',
  'rvm_without_gems' => 'rubygems-bundler',
  'rvm_autolibs_flag' => 'read-fail'
}
default['travis_build_environment']['golang_libraries'] = %w(
  golang.org/x/tools/cmd/cover
)
default['travis_build_environment']['rebar_release'] = \
  'https://github.com/rebar/rebar/wiki/rebar'
default['travis_build_environment']['kerl_path'] = '/usr/local/bin/kerl'
default['travis_build_environment']['kerl_base_dir'] = \
  "#{node['travis_build_environment']['home']}/.kerl"
default['travis_build_environment']['otp_releases'] = %w(
  17.5
  R16B03
)
default['travis_build_environment']['elixir_versions'] = %w(
  1.0.4
)
default['travis_build_environment']['required_otp_release_for'] = {
  '1.0.3' => '17.4',
  '1.0.4' => '17.5'
}
default['travis_build_environment']['default_elixir_version'] = '1.0.4'
default['travis_build_environment']['mysql']['password'] = 'travis'
default['travis_build_environment']['mysql']['socket'] = '/var/run/mysqld/mysqld.sock'
default['travis_build_environment']['packer_url'] = \
  'https://releases.hashicorp.com/packer/0.10.1/packer_0.10.1_linux_amd64.zip'
default['travis_build_environment']['packer_checksum'] = \
  '7d51fc5db19d02bbf32278a8116830fae33a3f9bd4440a58d23ad7c863e92e28'
default['travis_build_environment']['packer_version'] = '0.10.1'
default['travis_build_environment']['packer_binaries'] = %w(packer)
default['travis_build_environment']['ramfs_dir'] = '/var/ramfs'
default['travis_build_environment']['ramfs_size'] = '768m'
default['travis_build_environment']['bats_git_repository'] = \
  'https://github.com/sstephenson/bats.git'

default['travis_build_environment']['hhvm_enabled'] = true
default['travis_build_environment']['hhvm_package_name'] = 'hhvm'
default['travis_build_environment']['php_packages'] = %w(
  autoconf
  bison
  build-essential
  libbison-dev
  libfreetype6-dev
  libreadline6-dev
)
php_versions = %w(
  5.4.45
  5.5.30
  5.6.24
)
default['travis_build_environment']['php_versions'] = php_versions
default['travis_build_environment']['php_default_version'] = php_versions.max
default['travis_build_environment']['php_aliases'] = Hash[
  php_versions.map { |v| [v.split('.')[0, 2].join('.'), v] }
]

default['travis_build_environment']['arch'] = 'i386'
if kernel['machine'] =~ /x86_64/
  default['travis_build_environment']['arch'] = 'amd64'
end

default['travis_build_environment']['jq_install_dest'] = '/usr/local/bin/jq'

default['travis_build_environment']['sphinxsearch']['ppas'] = %w(
  ppa:builds/sphinxsearch-rel20
  ppa:builds/sphinxsearch-rel21
  ppa:builds/sphinxsearch-rel22
)
default['travis_build_environment']['clang']['version'] = '3.5.0'
default['travis_build_environment']['clang']['download_url'] = "http://llvm.org/releases/#{node['travis_build_environment']['clang']['version']}/clang+llvm-#{node['travis_build_environment']['clang']['version']}-x86_64-linux-gnu-ubuntu-14.04.tar.xz"
default['travis_build_environment']['clang']['extension'] = 'tar.xz'
default['travis_build_environment']['clang']['checksum'] = 'b9b420b93d7681bb2b809c3271ebdf4389c9b7ca35a781c7189d07d483d8f201'

default['travis_build_environment']['gimme']['url'] = 'https://raw.githubusercontent.com/travis-ci/gimme/v1.0.0/gimme'
default['travis_build_environment']['gimme']['sha256sum'] = '7283e248184bada52442e01608e107fb27fd3ecfc691d6e632fc2b5dc6e255ce'
default['travis_build_environment']['gimme']['default_version'] = ''
default['travis_build_environment']['gimme']['versions'] = %w()
default['travis_build_environment']['gimme']['install_user'] = 'travis'
default['travis_build_environment']['gimme']['install_user_home'] = '/home/travis'
default['travis_build_environment']['gimme']['debug'] = false

default['travis_build_environment']['sysctl_kernel_shmmax'] = 45_794_432
default['travis_build_environment']['sysctl_disable_ipv6'] = true
default['travis_build_environment']['wget']['version'] = '1.18'

default['travis_build_environment']['yarn_url'] = 'https://yarnpkg.com/downloads/0.17.8/yarn-v0.17.8.tar.gz'
default['travis_build_environment']['yarn_version'] = '0.17.8'
default['travis_build_environment']['yarn_checksum'] = 'b54e762e2a54f1fb23c6b0f9c239c3791aae05aface5ea0d6498f2a7979b541c'
default['travis_build_environment']['yarn_binaries'] = %w(bin/yarn bin/yarnpkg bin/yarn.js)

default['tz'] = 'UTC'
default['travis_java']['default_version'] = ''
override['rvm']['gpg']['keyserver'] = 'hkp://ha.pool.sks-keyservers.net'
