# frozen_string_literal: true

ark 'maven' do
  url node['travis_build_environment']['maven_url']
  version node['travis_build_environment']['maven_version']
  checksum node['travis_build_environment']['maven_checksum']
  strip_components 1
  retries 2
  retry_delay 30
  append_env_path true
end
