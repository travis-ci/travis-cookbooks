default_jvm = nil

unless node['travis_java']['default_version'].to_s.empty?
  include_recipe "travis_java::#{node['travis_java']['default_version']}"
  default_jvm = node['travis_java'][node['travis_java']['default_version']]['jvm_name']
end

include_recipe 'travis_java::jdk_switcher'

template '/etc/profile.d/travis-java.sh' do
  source 'travis-java.sh.erb'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
  variables(
    jdk_switcher_default: node['travis_java']['default_version'],
    jdk_switcher_path: node['travis_java']['jdk_switcher_path'],
    jvm_base_dir: node['travis_java']['jvm_base_dir'],
    jvm_name: default_jvm
  )
end

unless Array(node['travis_java']['alternate_versions']).empty?
  include_recipe 'travis_java::multi'
end

execute "set #{default_jvm} as default alternative" do
  command "update-java-alternatives -s #{default_jvm}"
  not_if { default_jvm.nil? }
end

# HACK: these files and symlinks are created by *something* (presumably the
# oracle-java8-installer), and they point to a version that is different and
# older than /usr/lib/jvm/java-8-oracle, which is *very confusing*, so let's get
# rid of them OK?
execute 'clean up busted jvm symlinks' do
  command %w(
    rm -f
    /usr/lib/jvm/default-java
    /usr/lib/jvm/java-8-oracle-amd64
    /usr/lib/jvm/.java-8-oracle-amd64.jinfo
  ).join(' ')
  action :nothing
end

log 'trigger jvm symlink cleanup' do
  level :info
  notifies :run, 'execute[clean up busted jvm symlinks]'
end
