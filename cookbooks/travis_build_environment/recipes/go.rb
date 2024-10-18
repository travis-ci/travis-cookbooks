# frozen_string_literal: true

# Cookbook:: travis_build_environment
# Recipe:: go

go_default_version = node['travis_build_environment']['go']['default_version'].to_s
go_versions = Array(node['travis_build_environment']['go']['versions'])
go_versions += [go_default_version] unless go_default_version.empty?

go_versions.each do |version|
  version = version.delete('go')

  log "Installing #{version}" do
    level :info
  end

  bash 'go install' do
    code "snap install go --channel=#{version}/stable --classic"
  end
end
