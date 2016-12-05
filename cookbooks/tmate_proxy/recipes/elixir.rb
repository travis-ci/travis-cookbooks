erlang_deb = 'erlang-solutions_1.0_all.deb'
checksum_deb = 'c939e40d1a57f8cfd664886097a46c2c896a3e35eede1b81b675a6e31b6d9e60'

remote_file "#{Chef::Config.file_cache_path}/#{erlang_deb}" do
  source "https://packages.erlang-solutions.com/#{erlang_deb}"
  checksum checksum_deb
  mode 0o644
end

dpkg_package 'esl-erlang' do
  source "#{Chef::Config.file_cache_path}/#{erlang_deb}"
  action :install
end

execute 'apt-get update -y'

package %w(esl-erlang elixir)
