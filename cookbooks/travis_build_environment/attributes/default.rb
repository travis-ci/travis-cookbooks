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

default['travis_build_environment']['rubies'] = %w(2.7.6 3.3.5)
default['travis_build_environment']['default_ruby'] = '3.3.5'
default['travis_build_environment']['gems'] = {}
default['travis_build_environment']['global_gems'] = %w()
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

default['travis_build_environment']['pyenv_revision'] = 'v2.6.5'
default['travis_build_environment']['pythons'] = %w(
  3.7.17
  3.12.4
  pypy2.7-7.3.1
  pypy3.8-7.3.9
)

default['travis_build_environment']['python_aliases'] = {
  '3.7.17' => %w(3.7),
  '3.12.4' => %w(3.12),
  'pypy2.7-7.3.1' => %w(pypy),
  'pypy3.8-7.3.9' => %w(pypy3),
}

default['travis_build_environment']['pip']['packages'] = {
  'default' => %w(nose mock setuptools wheel numpy pytest pip-tools build),
}

default['travis_build_environment']['system_python']['pythons'] = %w(3.7 3.12)

# case node['platform']
# when 'ubuntu'
#   if node['lsb']['codename'] == 'trusty'
#     default['travis_build_environment']['system_python']['pythons'] = %w(2.7 3.4)
#   elsif node['lsb']['codename'] == 'xenial'
#     default['travis_build_environment']['system_python']['pythons'] = %w(2.7 3.5)
#   elsif node['lsb']['codename'] == 'bionic'
#     default['travis_build_environment']['system_python']['pythons'] = %w(2.7 3.6)
#   else
#     default['travis_build_environment']['system_python']['pythons'] = %w(3.12)
#   end
# end

default['travis_build_environment']['rebar_url'] = 'https://github.com/rebar/rebar/wiki/rebar'
default['travis_build_environment']['rebar3_url'] = 'https://s3.amazonaws.com/rebar3/rebar3'
default['travis_build_environment']['rebar3_version'] = '3.6.2'
default['travis_build_environment']['rebar3_checksum'] = '2a107ee8f88de431d89f7a3bdccaf4b7bbba268cd02ab2e7ebf1e7976798b9bf'
default['travis_build_environment']['kerl_path'] = '/usr/local/bin/kerl'
default['travis_build_environment']['kerl_base_dir'] = "#{node['travis_build_environment']['home']}/.kerl"
default['travis_build_environment']['otp_releases'] = %w(25.3.2.6)
default['travis_build_environment']['elixir_versions'] = %w(1.7.4)
default['travis_build_environment']['required_otp_release_for']['1.7.4'] = '21.1'
default['travis_build_environment']['default_elixir_version'] = '1.7.4'
default['travis_build_environment']['mysql']['socket'] = '/var/run/mysqld/mysqld.sock'
default['travis_build_environment']['packer']['amd64']['version'] = '1.14.1'
default['travis_build_environment']['packer']['amd64']['checksum'] = 'b9c39b150fd856c6a6ab1639acc01a181d85033f4e0dc6c9ef87bbb692a59c31'
default['travis_build_environment']['packer']['ppc64le']['version'] = '1.7.5'
default['travis_build_environment']['packer']['ppc64le']['checksum'] = '32871bc5a610e2454177081d407cadcdce384c0dc1eb578f01435e667f922c9a'
default['travis_build_environment']['packer_binaries'] = %w(packer)
default['travis_build_environment']['ramfs_dir'] = '/var/ramfs'
default['travis_build_environment']['ramfs_size'] = '768m'
default['travis_build_environment']['bats_git_repository'] = 'https://github.com/bats-core/bats-core.git'

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
  8.3.6
)
default['travis_build_environment']['php_versions'] = php_versions
default['travis_build_environment']['php_default_version'] = php_versions.max
default['travis_build_environment']['php_aliases'] = Hash[
  php_versions.map { |v| [v.split('.')[0, 2].join('.'), v] }
]

nodejs_versions = %w(18.20.3)
default['travis_build_environment']['nodejs_versions'] = nodejs_versions
default['travis_build_environment']['nodejs_default'] = nodejs_versions.max
default['travis_build_environment']['nodejs_aliases'] = Hash[
  nodejs_versions.map { |v| [v.split('.')[0, 2].join('.'), v] }
]
default['travis_build_environment']['nodejs_default_modules'] = %w(grunt-cli)

default['travis_build_environment']['arch'] = 'i386'
if node['kernel']['machine'] =~ /x86_64/
  default['travis_build_environment']['arch'] = 'amd64'
end

default['travis_build_environment']['jq_install_dest'] = '/usr/local/bin/jq'

default['travis_build_environment']['sphinxsearch']['ppas'] = %w(
  ppa:builds/sphinxsearch-rel22
)

version = '9.1.0'
default['travis_build_environment']['elasticsearch']['version'] = version
default['travis_build_environment']['elasticsearch']['package_name'] = "elasticsearch-#{version}-amd64.deb"
default['travis_build_environment']['elasticsearch']['service_enabled'] = false
default['travis_build_environment']['elasticsearch']['jvm_heap'] = '128m'

default['travis_build_environment']['redis']['service_enabled'] = false
default['travis_build_environment']['redis']['keep_repo'] = false

default['travis_build_environment']['firefox_version'] = '141.0.3'
default['travis_build_environment']['firefox_download_url'] = ::File.join(
  'https://releases.mozilla.org/pub/firefox/releases',
  node['travis_build_environment']['firefox_version'],
  "linux-#{node['kernel']['machine']}/en-US",
  "firefox-#{node['travis_build_environment']['firefox_version']}.tar.xz"
)

default['travis_build_environment']['clang']['version'] = '18.1.8'
default['travis_build_environment']['clang']['download_url'] = ::File.join(
  "https://github.com/llvm/llvm-project/releases/download/llvmorg-#{node['travis_build_environment']['clang']['version']}",
  "clang+llvm-#{node['travis_build_environment']['clang']['version']}-x86_64-linux-gnu-ubuntu-18.04.tar.xz"
)
default['travis_build_environment']['clang']['extension'] = 'tar.xz'
default['travis_build_environment']['clang']['checksum'] = '54ec30358afcc9fb8aa74307db3046f5187f9fb89fb37064cdde906e062ebf36'

default['travis_build_environment']['cmake']['version'] = '4.1.0'
default['travis_build_environment']['cmake']['download_url'] = ::File.join(
  'https://cmake.org/files',
  "v#{default['travis_build_environment']['cmake']['version'].split('.')[0, 2].join('.')}",
  "cmake-#{default['travis_build_environment']['cmake']['version']}-linux-x86_64.tar.gz"
)
default['travis_build_environment']['cmake']['extension'] = 'tar.gz'
default['travis_build_environment']['cmake']['checksum'] = '2637dab096e65c7d011ca0504fc0c563f8ffb531919754156ddec4b7a2f8584d'

default['travis_build_environment']['go']['default_version'] = '1.24'
default['travis_build_environment']['go']['versions'] = %w(1.24)

default['travis_build_environment']['haskell']['ghc_versions'] = %w(9.0.1)
default['travis_build_environment']['haskell']['cabal_versions'] = %w(3.4)
default['travis_build_environment']['haskell']['keep_repo'] = false

gradle_version = '9.0.0'
default['travis_build_environment']['gradle_version'] = gradle_version
default['travis_build_environment']['gradle_url'] = "https://services.gradle.org/distributions/gradle-#{gradle_version}-bin.zip"
default['travis_build_environment']['gradle_checksum'] = '8fad3d78296ca518113f3d29016617c7f9367dc005f932bd9d93bf45ba46072b'

default['travis_build_environment']['lein_url'] = 'https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein'

default['travis_build_environment']['sysctl_kernel_shmmax'] = 45_794_432
default['travis_build_environment']['sysctl_disable_ipv6'] = true
default['travis_build_environment']['sysctl_enable_ipv4_forwarding'] = true

maven_version = '3.9.11'
default['travis_build_environment']['maven_version'] = maven_version
default['travis_build_environment']['maven_url'] = "https://downloads.apache.org/maven/maven-3/#{maven_version}/binaries/apache-maven-#{maven_version}-bin.tar.gz"
default['travis_build_environment']['maven_checksum'] = '4b7195b6a4f5c81af4c0212677a32ee8143643401bc6e1e8412e6b06ea82beac'

default['travis_build_environment']['neo4j']['service_enabled'] = false
default['travis_build_environment']['neo4j']['jvm_heap'] = '128m'
default['travis_build_environment']['neo4j_url'] = 'https://dist.neo4j.org/deb/neo4j-enterprise_5.26.0_all.deb'
default['travis_build_environment']['neo4j_version'] = '5.26.0'
default['travis_build_environment']['neo4j_checksum'] = 'de2fb1afec5b2259b5abf0d3fe492a68783f59c1893a1f5048d0b1e96b8dda9c'

default['travis_build_environment']['mercurial_install_type'] = 'ppa'
if node['kernel']['machine'] == 'ppc64le'
  default['travis_build_environment']['mercurial_install_type'] = 'src'
end
default['travis_build_environment']['mercurial_version'] = '7.1'
mercurial_ppc_version = '7.1'
default['travis_build_environment']['mercurial_ppc_version'] = mercurial_ppc_version
default['travis_build_environment']['mercurial_url'] = "https://www.mercurial-scm.org/release/mercurial-#{mercurial_ppc_version}.tar.gz"

default['travis_build_environment']['mongodb']['service_enabled'] = false
default['travis_build_environment']['mongodb']['keep_repo'] = false

default['travis_build_environment']['shellcheck_url'] = 'https://github.com/koalaman/shellcheck/releases/download/v0.11.0/shellcheck-v0.11.0.linux.x86_64.tar.xz'
default['travis_build_environment']['shellcheck_version'] = '0.11.0'
default['travis_build_environment']['shellcheck_checksum'] = '8c3be12b05d5c177a04c29e3c78ce89ac86f1595681cab149b65b97c4e227198'
default['travis_build_environment']['shellcheck_binaries'] = %w(shellcheck)

default['travis_build_environment']['shfmt_url'] = 'https://github.com/mvdan/sh/releases/download/v3.12.0/shfmt_v3.12.0_linux_amd64'
default['travis_build_environment']['shfmt_checksum'] = 'd9fbb2a9c33d13f47e7618cf362a914d029d02a6df124064fff04fd688a745ea'

default['travis_build_environment']['yarn_url'] = 'https://yarnpkg.com/latest.tar.gz'
default['travis_build_environment']['yarn_version'] = 'latest'
default['travis_build_environment']['yarn_binaries'] = %w(bin/yarn bin/yarn.js bin/yarnpkg)

default['tz'] = 'UTC'
default['travis_java']['default_version'] = ''
default['travis_build_environment']['couchdb']['keep_repo'] = false
default['travis_build_environment']['docker']['keep_repo'] = false
default['travis_build_environment']['git-lfs']['keep_repo'] = false
default['travis_build_environment']['git-ppa']['keep_repo'] = false
default['travis_build_environment']['google_chrome']['keep_repo'] = false
default['travis_build_environment']['disable_ntp'] = true

if File.exist?('/.dockerenv')
  default['travis_build_environment']['disable_ntp'] = false
end

default['travis_build_environment']['root_user'] = 'root'
default['travis_build_environment']['root_group'] = 'root'
default['travis_build_environment']['virtualenv']['version'] = '20.33.1'

if platform_family?('debian', 'rhel')
  default['travis_build_environment']['ibm_advanced_tool_chain_apt_key_url'] = ::File.join(
    'https://public.dhe.ibm.com/software/server/POWER/Linux/toolchain/at/ubuntu/dists',
    "#{node['lsb']['codename']}/6976a827.gpg.key"
  )
  default['travis_build_environment']['ibm_advanced_tool_chain_apt_deb_url'] =
    'https://public.dhe.ibm.com/software/server/POWER/Linux/toolchain/at/ubuntu'
else
  default['travis_build_environment']['ibm_advanced_tool_chain_apt_key_url'] = ''
  default['travis_build_environment']['ibm_advanced_tool_chain_apt_deb_url'] = ''
end
