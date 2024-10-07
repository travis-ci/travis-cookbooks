# frozen_string_literal: true

if node['lsb']['codename'] != 'bionic'

  apt_repository 'git-ppa' do
    uri 'ppa:git-core/ppa'
    retries 2
    retry_delay 30
  end

  case node['lsb']['codename']
  when 'trusty' || 'xenial'
    pkgs = %w(git git-core)
  when 'bionic'
    pkgs = %w(git)
  else
    pkgs = %w(git)
  end

  package pkgs do
    action %i(install upgrade)
  end

  case node['lsb']['codename']
  when 'trusty', 'xenial'
    packagecloud_repo_enable = true
  else
    packagecloud_repo_enable = false
  end

  packagecloud_repo 'github/git-lfs' do
    type 'deb'
    not_if { node['kernel']['machine'] == 'ppc64le' }
    only_if { packagecloud_repo_enable }
  end

  package 'git-lfs' do
    action %i(install upgrade)
    not_if { node['kernel']['machine'] == 'ppc64le' }
  end

  apt_repository 'git-ppa' do
    action :remove
    not_if { node['travis_build_environment']['git-ppa']['keep_repo'] }
  end

  execute 'remove git-lfs repo' do
    command 'rm -f /etc/apt/sources.list.d/github_git-lfs.list'
    not_if { node['kernel']['machine'] == 'ppc64le' }
    not_if { node['travis_build_environment']['git-lfs']['keep_repo'] }
    only_if { packagecloud_repo_enable }
  end

end
