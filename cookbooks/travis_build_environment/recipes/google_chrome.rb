# frozen_string_literal: true

apt_repository 'google-chrome' do
  uri 'http://dl.google.com/linux/chrome/deb/'
  arch 'amd64'
  distribution ''
  components %w[stable main]
  key 'https://dl-ssl.google.com/linux/linux_signing_key.pub'
  retries 2
  retry_delay 30
  not_if { node['kernel']['machine'] == 'ppc64le' }
end

package 'google-chrome-stable' do
  not_if { node['kernel']['machine'] == 'ppc64le' }
end

apt_repository 'google-chrome' do
  action :remove
  not_if { node['travis_build_environment']['google_chrome']['keep_repo'] }
  not_if { node['kernel']['machine'] == 'ppc64le' }
end

ruby_block 'job_board adjustments google-chrome ppc64le' do
  only_if { node['kernel']['machine'] == 'ppc64le' }
  block do
    features = node['travis_packer_templates']['job_board']['features'] - ['google-chrome']
    node.override['travis_packer_templates']['job_board']['features'] = features
  end
end
