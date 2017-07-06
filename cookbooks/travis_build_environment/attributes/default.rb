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
default['travis_build_environment']['language_codes'] = %w[
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
].map { |l| "#{l}.UTF-8" }
default['travis_build_environment']['rubies'] = %w[1.9.3-p551 2.2.3]
default['travis_build_environment']['default_ruby'] = '2.2.3'
default['travis_build_environment']['gems'] = {}
default['travis_build_environment']['global_gems'] = %w[
  bundler
  nokogiri
  rake
].map { |gem| { name: gem } }
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

default['travis_build_environment']['pyenv_revision'] = 'v1.0.6'

# Order matters for this list of Pythons. It will be used to construct the
# $PATH so items earlier in the list will take precedence over items later in
# the list. This order means that ``python`` will be 2.7.13, ``python2`` will be
# 2.7.13, and ``python3`` will be 3.6.1
default['travis_build_environment']['pythons'] = %w[
  2.7.13
  3.6.1
  pypy2-5.6.0
]

default['travis_build_environment']['python_aliases'] = {
  '2.7.13' => %w[2.7],
  '3.6.1' => %w[3.6],
  'pypy2-5.6.0' => %w[pypy]
}

default['travis_build_environment']['pip']['packages'] = {
  'default' => %w[nose pytest mock wheel],
  '2.7' => %w[numpy],
  '3.6' => %w[numpy]
}

default['travis_build_environment']['system_python']['pythons'] = %w[2.7 3.2]
if node['lsb']['codename'] == 'trusty'
  default['travis_build_environment']['system_python']['pythons'] = %w[2.7 3.4]
end

default['travis_build_environment']['rebar_url'] = \
  'https://github.com/rebar/rebar/wiki/rebar'
default['travis_build_environment']['rebar3_url'] = \
  'https://s3.amazonaws.com/rebar3/rebar3'
default['travis_build_environment']['kerl_path'] = '/usr/local/bin/kerl'
default['travis_build_environment']['kerl_base_dir'] = \
  "#{node['travis_build_environment']['home']}/.kerl"
default['travis_build_environment']['otp_releases'] = %w[
  17.5
  R16B03
]
default['travis_build_environment']['elixir_versions'] = %w[
  1.0.4
]
default['travis_build_environment']['required_otp_release_for'] = {
  '1.0.3' => '17.4',
  '1.0.4' => '17.5'
}
default['travis_build_environment']['default_elixir_version'] = '1.0.4'
default['travis_build_environment']['mysql']['socket'] = '/var/run/mysqld/mysqld.sock'
default['travis_build_environment']['packer_url'] = \
  'https://releases.hashicorp.com/packer/0.10.1/packer_0.10.1_linux_amd64.zip'
default['travis_build_environment']['packer_checksum'] = \
  '7d51fc5db19d02bbf32278a8116830fae33a3f9bd4440a58d23ad7c863e92e28'
default['travis_build_environment']['packer_version'] = '0.10.1'
default['travis_build_environment']['packer_binaries'] = %w[packer]
default['travis_build_environment']['ramfs_dir'] = '/var/ramfs'
default['travis_build_environment']['ramfs_size'] = '768m'
default['travis_build_environment']['bats_git_repository'] = \
  'https://github.com/sstephenson/bats.git'

default['travis_build_environment']['hhvm_enabled'] = true
default['travis_build_environment']['hhvm_package_name'] = 'hhvm'
default['travis_build_environment']['php_packages'] = %w[
  autoconf
  bison
  build-essential
  libbison-dev
  libfreetype6-dev
  libreadline6-dev
]
php_versions = %w[
  5.4.45
  5.5.30
  5.6.24
]
default['travis_build_environment']['php_versions'] = php_versions
default['travis_build_environment']['php_default_version'] = php_versions.max
default['travis_build_environment']['php_aliases'] = Hash[
  php_versions.map { |v| [v.split('.')[0, 2].join('.'), v] }
]

nodejs_versions = %w[
  7.4.0
]

default['travis_build_environment']['nodejs_versions'] = nodejs_versions
default['travis_build_environment']['nodejs_default'] = nodejs_versions.max
default['travis_build_environment']['nodejs_aliases'] = Hash[
  nodejs_versions.map { |v| [v.split('.')[0, 2].join('.'), v] }
]
default['travis_build_environment']['nodejs_default_modules'] = %w[
  grunt-cli
]

default['travis_build_environment']['nvm']['url'] = 'https://raw.githubusercontent.com/creationix/nvm/v0.33.0/nvm.sh'
default['travis_build_environment']['nvm']['sha256sum'] = '40208b5d10788c257fa4bf7619f4fde57476c75d3e99e17b1cd9b9f413d11a39'

default['travis_build_environment']['arch'] = 'i386'
if node['kernel']['machine'] =~ /x86_64/
  default['travis_build_environment']['arch'] = 'amd64'
end

default['travis_build_environment']['jq_install_dest'] = '/usr/local/bin/jq'

default['travis_build_environment']['sphinxsearch']['ppas'] = %w[
  ppa:builds/sphinxsearch-rel20
  ppa:builds/sphinxsearch-rel21
  ppa:builds/sphinxsearch-rel22
]

default['travis_build_environment']['elasticsearch']['version'] = '5.4.3'
default['travis_build_environment']['elasticsearch']['service_enabled'] = false
default['travis_build_environment']['elasticsearch']['jvm_heap'] = '128m'

default['travis_build_environment']['redis']['service_enabled'] = false

default['travis_build_environment']['firefox_version'] = '50.0.2'
default['travis_build_environment']['firefox_download_url'] = ::File.join(
  'https://releases.mozilla.org/pub/firefox/releases',
  node['travis_build_environment']['firefox_version'],
  "linux-#{node['kernel']['machine']}/en-US",
  "firefox-#{node['travis_build_environment']['firefox_version']}.tar.bz2"
)

default['travis_build_environment']['clang']['version'] = '3.5.0'
default['travis_build_environment']['clang']['download_url'] = "http://llvm.org/releases/#{node['travis_build_environment']['clang']['version']}/clang+llvm-#{node['travis_build_environment']['clang']['version']}-x86_64-linux-gnu-ubuntu-14.04.tar.xz"
default['travis_build_environment']['clang']['extension'] = 'tar.xz'
default['travis_build_environment']['clang']['checksum'] = 'b9b420b93d7681bb2b809c3271ebdf4389c9b7ca35a781c7189d07d483d8f201'

default['travis_build_environment']['gimme']['url'] = 'https://raw.githubusercontent.com/travis-ci/gimme/v1.0.0/gimme'
default['travis_build_environment']['gimme']['sha256sum'] = '7283e248184bada52442e01608e107fb27fd3ecfc691d6e632fc2b5dc6e255ce'
default['travis_build_environment']['gimme']['default_version'] = ''
default['travis_build_environment']['gimme']['versions'] = %w[]
default['travis_build_environment']['gimme']['install_user'] = 'travis'
default['travis_build_environment']['gimme']['install_user_home'] = '/home/travis'
default['travis_build_environment']['gimme']['debug'] = false

default['travis_build_environment']['haskell_ghc_versions'] = %w[
  7.0.4
  7.4.2
  7.6.3
  7.8.4
  7.10.3
  8.0.2
]
default['travis_build_environment']['haskell_cabal_versions'] = %w[
  1.16
  1.18
  1.20
  1.22
  1.24
]
default['travis_build_environment']['haskell_default_ghc'] = '7.6.3'
default['travis_build_environment']['haskell_default_cabal'] = '1.18'

gradle_version = '3.2.1'
default['travis_build_environment']['gradle_version'] = gradle_version
default['travis_build_environment']['gradle_url'] = "https://services.gradle.org/distributions/gradle-#{gradle_version}-bin.zip"
default['travis_build_environment']['gradle_checksum'] = '9843a3654d3e57dce54db06d05f18b664b95c22bf90c6becccb61fc63ce60689'

default['travis_build_environment']['lein_url'] = 'https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein'

default['travis_build_environment']['sysctl_kernel_shmmax'] = 45_794_432
default['travis_build_environment']['sysctl_disable_ipv6'] = true
default['travis_build_environment']['wget']['version'] = '1.18'

default['travis_build_environment']['maven_url'] = 'https://www.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz'
default['travis_build_environment']['maven_version'] = '3.3.9'
default['travis_build_environment']['maven_checksum'] = '6e3e9c949ab4695a204f74038717aa7b2689b1be94875899ac1b3fe42800ff82'
default['travis_build_environment']['maven_binaries'] = %w[
  bin/m2.conf
  bin/mvn
  bin/mvn.cmd
  bin/mvnDebug
  bin/mvnDebug.cmd
  bin/mvnyjp
]

default['travis_build_environment']['neo4j']['service_enabled'] = false
default['travis_build_environment']['neo4j']['jvm_heap'] = '128m'
default['travis_build_environment']['neo4j_url'] = 'https://neo4j.com/artifact.php?name=neo4j-community-3.2.1-unix.tar.gz'
default['travis_build_environment']['neo4j_version'] = '3.2.1'
default['travis_build_environment']['neo4j_checksum'] = '24fd6a704e0d80c4b4f9a3d17ce0db23f258a8cdcfa1eb28d7803b7d1811ee96'

default['travis_build_environment']['mercurial_install_type'] = 'ppa'
default['travis_build_environment']['mercurial_version'] = '4.1.3~trusty1'

default['travis_build_environment']['shellcheck_url'] = 'https://s3.amazonaws.com/travis-blue-public/binaries/ubuntu/14.04/x86_64/shellcheck-0.4.5.tar.bz2'
default['travis_build_environment']['shellcheck_version'] = '0.4.5'
default['travis_build_environment']['shellcheck_checksum'] = '82397d9993d01daee52cebb672e782c596dc7ec928a199c709a20bd24c2941c9'
default['travis_build_environment']['shellcheck_binaries'] = %w[shellcheck]

default['travis_build_environment']['shfmt_url'] = 'https://github.com/mvdan/sh/releases/download/v1.0.0/shfmt_v1.0.0_linux_amd64'
default['travis_build_environment']['shfmt_checksum'] = '172d2cf2d7d71191b7b0cd0d7169d703475825cdd270a6982899a349dcd98588'

default['travis_build_environment']['yarn_url'] = 'https://yarnpkg.com/downloads/0.17.8/yarn-v0.17.8.tar.gz'
default['travis_build_environment']['yarn_version'] = '0.17.8'
default['travis_build_environment']['yarn_checksum'] = 'b54e762e2a54f1fb23c6b0f9c239c3791aae05aface5ea0d6498f2a7979b541c'
default['travis_build_environment']['yarn_binaries'] = %w[bin/yarn bin/yarnpkg bin/yarn.js]

default['tz'] = 'UTC'
default['travis_java']['default_version'] = ''
