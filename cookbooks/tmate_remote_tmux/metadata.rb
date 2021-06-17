# frozen_string_literal: true

name 'tmate_remote_tmux'
maintainer 'Travis CI GmbH'
maintainer_email 'contact+packer-templates@travis-ci.org'
license 'MIT'
description 'Installs/Configures tmate_remote_tmux'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url 'https://github.com/travis-ci/travis-cookbooks/issues'
source_url 'https://github.com/travis-ci/travis-cookbooks/master/cookbooks/tmate_remote_tmux'
version '0.1.0'
chef_version '~> 13' if respond_to?(:chef_version)
