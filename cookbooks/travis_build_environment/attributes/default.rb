default['travis_build_environment']['user'] = 'travis'
default['travis_build_environment']['group'] = node['travis_build_environment']['user']
default['travis_build_environment']['password'] = node['travis_build_environment']['user']
default['travis_build_environment']['home'] = "/home/#{node['travis_build_environment']['user']}"
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
  'rvm_remote_flag' => '1',
  'rvm_gem_options' => '--no-ri --no-rdoc',
  'rvm_max_time_flag' => '5',
  'rvm_path' => "#{node['travis_build_environment']['home']}/.rvm",
  'rvm_project_rvmrc' => '0',
  'rvm_remote_server_type3' => 'rubies',
  'rvm_remote_server_url3' => 'https://s3.amazonaws.com/travis-rubies/binaries',
  'rvm_remote_server_verify_downloads3' => '1',
  'rvm_silence_path_mismatch_check_flag' => '1',
  'rvm_user_install_flag' => '1',
  'rvm_with_default_gems' => 'rake bundler',
  'rvm_without_gems' => 'rubygems-bundler'
}
default['travis_build_environment']['prerequisite_recipes'] = %w(
  travis_timezone
  sysctl
  openssh
  unarchivers
)
default['travis_build_environment']['postrequisite_recipes'] = %w(
  iptables
)

default['travis_build_environment']['arch'] = 'i386'
if kernel['machine'] =~ /x86_64/
  default['travis_build_environment']['arch'] = 'amd64'
end

default['travis_java']['default_version'] = ''
