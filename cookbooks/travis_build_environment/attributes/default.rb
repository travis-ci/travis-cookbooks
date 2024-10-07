# frozen_string_literal: true

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
default['travis_build_environment']['rubies'] = %w(2.2.7 2.4.1 2.7.4)
default['travis_build_environment']['default_ruby'] = '2.7.4'
default['travis_build_environment']['gems'] = {}
default['travis_build_environment']['global_gems'] = %w(
  bundler:2.4.13
  nokogiri
  rake
  cookstyle
).map { |gem| { name: gem } }
default['travis_build_environment']['rvm_release'] = 'stable'
default['travis_build_environment']['rvmrc_env'] = {
  'rvm_autoupdate_flag' => '0',
  'rvm_binary_flag' => '1',
  'rvm_fuzzy_flag' => '1',
  'rvm_gem_options' => '--no-document',
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
  'rvm_autolibs_flag' => 'read-fail',
}

default['travis_build_environment']['pyenv_revision'] = 'v2.2.2'

# Order matters for this list of Pythons. It will be used to construct the
# $PATH so items earlier in the list will take precedence over items later in
# the list. This order means that ``python`` will be 2.7.x, ``python2`` will be
# 2.7.x, and ``python3`` will be 3.6.x
# For the list of supported aliases, see:
# https://github.com/pyenv/pyenv/tree/master/plugins/python-build/share/python-build
default['travis_build_environment']['pythons'] = %w(
  2.7.14
  3.6.3
  pypy2.7-5.8.0
  pypy3.5-5.8.0
)

default['travis_build_environment']['python_aliases'] = {
  '2.7.14' => %w(2.7),
  '3.6.3' => %w(3.6),
  'pypy2.7-5.8.0' => %w(pypy),
  'pypy3.5-5.8.0' => %w(pypy3),
}

default['travis_build_environment']['pip']['packages'] = {
  'default' => %w(nose mock setuptools wheel),
  '2.7' => %w(numpy),
  '3.6' => %w(numpy),
}

default['travis_build_environment']['system_python']['pythons'] = %w(2.7 3.2)
case node['platform']
when 'ubuntu'
  if node['lsb']['codename'] == 'trusty'
    default['travis_build_environment']['system_python']['pythons'] = %w(2.7 3.4)
  elsif node['lsb']['codename'] == 'xenial'
    default['travis_build_environment']['system_python']['pythons'] = %w(2.7 3.5)
  elsif node['lsb']['codename'] == 'bionic'
    default['travis_build_environment']['system_python']['pythons'] = %w(2.7 3.6)
  else
    default['travis_build_environment']['system_python']['pythons'] = %w(3.7)
  end
end

default['travis_build_environment']['rebar_url'] = \
  'https://github.com/rebar/rebar/wiki/rebar'
default['travis_build_environment']['rebar3_url'] = 'https://s3.amazonaws.com/rebar3/rebar3'
default['travis_build_environment']['rebar3_version'] = '3.6.2'
default['travis_build_environment']['rebar3_checksum'] = '2a107ee8f88de431d89f7a3bdccaf4b7bbba268cd02ab2e7ebf1e7976798b9bf'
default['travis_build_environment']['kerl_path'] = '/usr/local/bin/kerl'
default['travis_build_environment']['kerl_base_dir'] = \
  "#{node['travis_build_environment']['home']}/.kerl"
default['travis_build_environment']['otp_releases'] = %w(
  23.3.1
)
default['travis_build_environment']['elixir_versions'] = %w(
  1.7.4
)
default['travis_build_environment']['required_otp_release_for']['1.7.4'] = '21.1'
default['travis_build_environment']['default_elixir_version'] = '1.7.4'
default['travis_build_environment']['mysql']['socket'] = '/var/run/mysqld/mysqld.sock'
default['travis_build_environment']['packer']['amd64']['version'] = '1.7.5'
default['travis_build_environment']['packer']['amd64']['checksum'] = \
  'a574d20719e86d9d38854050184b78d158e62619b2a4b33b79d03b94c782dbc5'
default['travis_build_environment']['packer']['ppc64le']['version'] = '1.7.5'
default['travis_build_environment']['packer']['ppc64le']['checksum'] = \
  '32871bc5a610e2454177081d407cadcdce384c0dc1eb578f01435e667f922c9a'
default['travis_build_environment']['packer_binaries'] = %w(packer)
default['travis_build_environment']['ramfs_dir'] = '/var/ramfs'
default['travis_build_environment']['ramfs_size'] = '768m'
default['travis_build_environment']['bats_git_repository'] = \
  'https://github.com/bats-core/bats-core.git'

default['travis_build_environment']['hhvm']['enabled'] = false
default['travis_build_environment']['hhvm']['package_name'] = 'hhvm'
default['travis_build_environment']['hhvm']['keep_repo'] = false
default['travis_build_environment']['php_packages'] = %w(
  autoconf
  bison
  build-essential
  libbison-dev
  libfreetype6-dev
  libreadline6-dev
)
php_versions = %w(
  5.6.32
  7.0.25
  7.1.11
)
default['travis_build_environment']['php_versions'] = php_versions
default['travis_build_environment']['php_default_version'] = php_versions.max
default['travis_build_environment']['php_aliases'] = Hash[
  php_versions.map { |v| [v.split('.')[0, 2].join('.'), v] }
]

nodejs_versions = %w(
  16.15.1
)

default['travis_build_environment']['nodejs_versions'] = nodejs_versions
default['travis_build_environment']['nodejs_default'] = nodejs_versions.max
default['travis_build_environment']['nodejs_aliases'] = Hash[
  nodejs_versions.map { |v| [v.split('.')[0, 2].join('.'), v] }
]
default['travis_build_environment']['nodejs_default_modules'] = %w(
  grunt-cli
)

default['travis_build_environment']['arch'] = 'i386'
if node['kernel']['machine'] =~ /x86_64/
  default['travis_build_environment']['arch'] = 'amd64'
end

default['travis_build_environment']['jq_install_dest'] = '/usr/local/bin/jq'

default['travis_build_environment']['sphinxsearch']['ppas'] = %w(
  ppa:builds/sphinxsearch-rel22
)

version = '7.16.3'
default['travis_build_environment']['elasticsearch']['version'] = version
default['travis_build_environment']['elasticsearch']['package_name'] = "elasticsearch-#{version}-amd64.deb"
# Latest versions of elasticsearch provide arch specific deb files which are not available for ppc64le
# Use noarch elasticsearch deb file for ppc64le
if node['kernel']['machine'] == 'ppc64le'
  version = '6.8.23'
  default['travis_build_environment']['elasticsearch']['version'] = version
  default['travis_build_environment']['elasticsearch']['package_name'] = "elasticsearch-#{version}-amd64.deb"
end
default['travis_build_environment']['elasticsearch']['service_enabled'] = false
default['travis_build_environment']['elasticsearch']['jvm_heap'] = '128m'

default['travis_build_environment']['redis']['service_enabled'] = false
default['travis_build_environment']['redis']['keep_repo'] = false

default['travis_build_environment']['firefox_version'] = '63.0.1'
default['travis_build_environment']['firefox_download_url'] = ::File.join(
  'https://releases.mozilla.org/pub/firefox/releases',
  node['travis_build_environment']['firefox_version'],
  "linux-#{node['kernel']['machine']}/en-US",
  "firefox-#{node['travis_build_environment']['firefox_version']}.tar.bz2"
)

default['travis_build_environment']['clang']['version'] = '16.0.0'
default['travis_build_environment']['clang']['download_url'] = ::File.join(
  "https://github.com/llvm/llvm-project/releases/download/llvmorg-#{node['travis_build_environment']['clang']['version']}",
  "clang+llvm-#{node['travis_build_environment']['clang']['version']}-x86_64-linux-gnu-ubuntu-18.04.tar.xz"
)

default['travis_build_environment']['clang']['extension'] = 'tar.xz'
default['travis_build_environment']['clang']['checksum'] = '2b8a69798e8dddeb57a186ecac217a35ea45607cb2b3cf30014431cff4340ad1'

default['travis_build_environment']['cmake']['version'] = '3.26.3'
default['travis_build_environment']['cmake']['download_url'] = ::File.join(
  'https://cmake.org/files',
  "v#{node['travis_build_environment']['cmake']['version'].split('.')[0, 2].join('.')}",
  "cmake-#{node['travis_build_environment']['cmake']['version']}-linux-x86_64.tar.gz"
)

default['travis_build_environment']['cmake']['extension'] = 'tar.gz'
default['travis_build_environment']['cmake']['checksum'] = '28d4d1d0db94b47d8dfd4f7dec969a3c747304f4a28ddd6fd340f553f2384dc2'

default['travis_build_environment']['gimme']['default_version'] = '1.22.5'
default['travis_build_environment']['gimme']['versions'] = %w(1.22.5)
default['travis_build_environment']['gimme']['install_user'] = 'travis'
default['travis_build_environment']['gimme']['install_user_home'] = '/home/travis'
default['travis_build_environment']['gimme']['debug'] = false

default['travis_build_environment']['haskell']['ghc_versions'] = %w(
  8.6.1
)
default['travis_build_environment']['haskell']['cabal_versions'] = %w(
  2.2
  2.4
)
default['travis_build_environment']['haskell']['keep_repo'] = false

gradle_version = '8.3'
default['travis_build_environment']['gradle_version'] = gradle_version
default['travis_build_environment']['gradle_url'] = "https://services.gradle.org/distributions/gradle-#{gradle_version}-bin.zip"
default['travis_build_environment']['gradle_checksum'] = '591855b517fc635b9e04de1d05d5e76ada3f89f5fc76f87978d1b245b4f69225'

default['travis_build_environment']['lein_url'] = 'https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein'

default['travis_build_environment']['sysctl_kernel_shmmax'] = 45_794_432
default['travis_build_environment']['sysctl_disable_ipv6'] = true
default['travis_build_environment']['sysctl_enable_ipv4_forwarding'] = true

maven_version = '3.9.4'
default['travis_build_environment']['maven_version'] = maven_version
default['travis_build_environment']['maven_url'] = "https://downloads.apache.org/maven/maven-3/#{maven_version}/binaries/apache-maven-#{maven_version}-bin.tar.gz"
default['travis_build_environment']['maven_checksum'] = 'ff66b70c830a38d331d44f6c25a37b582471def9a161c93902bac7bea3098319'

default['travis_build_environment']['neo4j']['service_enabled'] = false
default['travis_build_environment']['neo4j']['jvm_heap'] = '128m'
default['travis_build_environment']['neo4j_url'] = 'https://dist.neo4j.org/deb/neo4j-enterprise_5.12.0_all.deb'
default['travis_build_environment']['neo4j_version'] = '5.12.0'
default['travis_build_environment']['neo4j_checksum'] = '16c9af19b415758633088d93406be6bbbd6ca670ba87a47cfddb630e0681fed6'

default['travis_build_environment']['mercurial_install_type'] = 'ppa'
if node['kernel']['machine'] == 'ppc64le'
  default['travis_build_environment']['mercurial_install_type'] = 'src'
end
default['travis_build_environment']['mercurial_version'] = '4.2.2~trusty1'
mercurial_ppc_version = '4.2.2'
default['travis_build_environment']['mercurial_ppc_version'] = mercurial_ppc_version
default['travis_build_environment']['mercurial_url'] = "https://www.mercurial-scm.org/release/mercurial-#{mercurial_ppc_version}.tar.gz"

default['travis_build_environment']['mongodb']['service_enabled'] = false
default['travis_build_environment']['mongodb']['keep_repo'] = false

default['travis_build_environment']['shellcheck_url'] = 'https://github.com/koalaman/shellcheck/releases/download/v0.10.0/shellcheck-v0.10.0.linux.x86_64.tar.xz'
default['travis_build_environment']['shellcheck_version'] = '0.10.0'
default['travis_build_environment']['shellcheck_checksum'] = '6c881ab0698e4e6ea235245f22832860544f17ba386442fe7e9d629f8cbedf87'
default['travis_build_environment']['shellcheck_binaries'] = %w(shellcheck)

default['travis_build_environment']['shfmt_url'] = 'https://github.com/mvdan/sh/releases/download/v3.8.0/shfmt_v3.8.0_linux_amd64'
default['travis_build_environment']['shfmt_checksum'] = '27b3c6f9d9592fc5b4856c341d1ff2c88856709b9e76469313642a1d7b558fe0'

default['travis_build_environment']['yarn_url'] = 'https://yarnpkg.com/latest.tar.gz'
default['travis_build_environment']['yarn_version'] = 'latest'
default['travis_build_environment']['yarn_binaries'] = %w(
  bin/yarn
  bin/yarn.js
  bin/yarnpkg
)

default['tz'] = 'UTC'
default['travis_java']['default_version'] = ''

default['travis_build_environment']['couchdb']['keep_repo'] = false
default['travis_build_environment']['docker']['keep_repo'] = false
default['travis_build_environment']['git-lfs']['keep_repo'] = false
default['travis_build_environment']['git-ppa']['keep_repo'] = false
default['travis_build_environment']['google_chrome']['keep_repo'] = false
# default['travis_build_environment']['pollinate']['keep_repo'] = false

default['travis_build_environment']['disable_ntp'] = true
if File.exist?('/.dockerenv')
  default['travis_build_environment']['disable_ntp'] = false
end

default['travis_build_environment']['root_user'] = 'root'
default['travis_build_environment']['root_group'] = 'root'

default['travis_build_environment']['virtualenv']['version'] = '15.1.0'

default['travis_build_environment']['ibm_advanced_tool_chain_apt_key_url'] = ::File.join(
  'https://public.dhe.ibm.com/software/server/POWER/Linux/toolchain/at/ubuntu/dists',
  "#{node['lsb']['codename']}/6976a827.gpg.key"
)
default['travis_build_environment']['ibm_advanced_tool_chain_apt_deb_url'] =
  'https://public.dhe.ibm.com/software/server/POWER/Linux/toolchain/at/ubuntu'
