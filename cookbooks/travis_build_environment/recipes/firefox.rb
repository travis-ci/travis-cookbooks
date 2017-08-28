package %w[
  libasound2
  libatk1.0-0
  libc6
  libcairo2
  libdbus-1-3
  libdbus-glib-1-2
  libfontconfig1
  libfreetype6
  libgcc1
  libgdk-pixbuf2.0-0
  libglib2.0-0
  libgtk2.0-0
  libnotify4
  libpango1.0-0
  libstartup-notification0
  libstdc++6
  libx11-6
  libxext6
  libxrender1
  libxt6
  lsb-release
] do
  action %i[install upgrade]
end

ark 'firefox' do
  url node['travis_build_environment']['firefox_download_url']
  version node['travis_build_environment']['firefox_version']
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  has_binaries %w[firefox firefox-bin]
  not_if { node['kernel']['machine'] == 'ppc64le' }
end

package %w[firefox] do
  action %i[install upgrade]
  only_if { node['kernel']['machine'] == 'ppc64le' }
end
