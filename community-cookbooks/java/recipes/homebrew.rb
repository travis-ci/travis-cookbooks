include_recipe 'homebrew'
include_recipe 'homebrew::cask'
include_recipe 'java::notify'

homebrew_tap 'caskroom/versions'
homebrew_cask "java#{node['java']['jdk_version']}" do
  notifies :write, 'log[jdk-version-changed]', :immediately
end
