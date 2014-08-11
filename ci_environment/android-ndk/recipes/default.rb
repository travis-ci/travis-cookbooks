setup_root        = node['android-ndk']['setup_root'].to_s.empty? ? node['ark']['prefix_home'] : node['android-ndk']['setup_root']
android_ndk_home  = File.join(setup_root, node['android-ndk']['name'])

#
# Download and setup android-sdk tarball package
#
ark node['android-ndk']['name'] do
  url         node['android-ndk']['download_url']
  checksum    node['android-ndk']['checksum']
  version     node['android-ndk']['version']
  prefix_root node['android-ndk']['setup_root']
  prefix_home node['android-ndk']['setup_root']
  owner       node['android-ndk']['owner']
  group       node['android-ndk']['group']
end

# TODO find a way to handle 'chmod stuff' below with own chef resource (idempotence stuff...)
execute 'Grant all users to read android files' do
  command       "chmod -R a+r #{android_ndk_home}/*"
  user          node['android-ndk']['owner']
  group         node['android-ndk']['group']
end

#
# Configure environment variables (ANDROID_HOME and PATH)
#
template "/etc/profile.d/android-ndk.sh"  do
  source "android-ndk.sh.erb"
  mode   0644
  owner  node['android-ndk']['owner']
  group  node['android-ndk']['group']
  variables(
    :android_ndk => android_ndk_home
  )
end
