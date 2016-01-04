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
  'rvm_without_gems' => 'rubygems-bundler'
}
default['travis_build_environment']['golang_libraries'] = %w(
  golang.org/x/tools/cmd/cover
  github.com/alecthomas/gometalinter
)
default['travis_build_environment']['install_gometalinter_tools'] = true
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
default['travis_build_environment']['prerequisite_recipes'] = %w(
  travis_timezone
  sysctl
  openssh
  unarchivers
)
default['travis_build_environment']['postrequisite_recipes'] = %w(
  iptables
)
default['travis_build_environment']['packer_url'] = \
  'https://releases.hashicorp.com/packer/0.8.6/packer_0.8.6_linux_amd64.zip'
default['travis_build_environment']['packer_checksum'] = \
  '2f1ca794e51de831ace30792ab0886aca516bf6b407f6027e816ba7ca79703b5'
default['travis_build_environment']['packer_version'] = '0.8.6'
default['travis_build_environment']['packer_binaries'] = %w(
  packer
  packer-builder-amazon-chroot
  packer-builder-amazon-ebs
  packer-builder-amazon-instance
  packer-builder-digitalocean
  packer-builder-docker
  packer-builder-file
  packer-builder-googlecompute
  packer-builder-null
  packer-builder-openstack
  packer-builder-parallels-iso
  packer-builder-parallels-pvm
  packer-builder-qemu
  packer-builder-virtualbox-iso
  packer-builder-virtualbox-ovf
  packer-builder-vmware-iso
  packer-builder-vmware-vmx
  packer-post-processor-artifice
  packer-post-processor-atlas
  packer-post-processor-compress
  packer-post-processor-docker-import
  packer-post-processor-docker-push
  packer-post-processor-docker-save
  packer-post-processor-docker-tag
  packer-post-processor-vagrant
  packer-post-processor-vagrant-cloud
  packer-post-processor-vsphere
  packer-provisioner-ansible-local
  packer-provisioner-chef-client
  packer-provisioner-chef-solo
  packer-provisioner-file
  packer-provisioner-powershell
  packer-provisioner-puppet-masterless
  packer-provisioner-puppet-server
  packer-provisioner-salt-masterless
  packer-provisioner-shell
  packer-provisioner-shell-local
  packer-provisioner-windows-restart
  packer-provisioner-windows-shell
)
default['travis_build_environment']['ramfs_dir'] = '/var/ramfs'
default['travis_build_environment']['ramfs_size'] = '768m'
default['travis_build_environment']['bats_git_repository'] = \
  'https://github.com/sstephenson/bats.git'

default['travis_build_environment']['arch'] = 'i386'
if kernel['machine'] =~ /x86_64/
  default['travis_build_environment']['arch'] = 'amd64'
end

default['travis_java']['default_version'] = ''
