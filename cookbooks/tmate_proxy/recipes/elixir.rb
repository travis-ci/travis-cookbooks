# frozen_string_literal: true

erlang_deb = "erlang-solutions_1.0_all.deb"
checksum_deb = "becd942327a3e2e9ee8a789816ffdda0e69364b03bc68656a1e0e69f3413757c"

remote_file "#{Chef::Config.file_cache_path}/#{erlang_deb}" do
  source "https://packages.erlang-solutions.com/#{erlang_deb}"
  checksum checksum_deb
  mode 0o644
end

dpkg_package "esl-erlang" do
  source "#{Chef::Config.file_cache_path}/#{erlang_deb}"
  action :install
end

execute "apt-get-update" do
  command "apt-get update"
end

package "esl-erlang"
package "elixir"
