# frozen_string_literal: true

default_jvm = nil
default_java_version = node['travis_java']['default_version']

if node['kernel']['machine'] == 'ppc64le'
  if default_java_version =~ /oraclejdk/ || default_java_version == 'openjdk6'
    default_java_version = ''
  end
end

unless default_java_version.to_s.empty?
  include_recipe "travis_java::#{default_java_version}"
  default_jvm = node['travis_java'][default_java_version]['jvm_name']
end

include_recipe 'travis_java::jdk_switcher'
include_recipe 'travis_build_environment::bash_profile_d'

template ::File.join(
  node['travis_build_environment']['home'],
  '.bash_profile.d/travis-java.bash'
) do
  source 'travis-java.bash.erb'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
  variables(
    jdk_switcher_default: default_java_version,
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
  action :nothing
end

# HACK: these files and symlinks are created by *something* (presumably the
# oracle-java8-installer), and they point to a version that is different and
# older than /usr/lib/jvm/java-8-oracle, which is *very confusing*, so let's get
# rid of them OK?
execute 'clean up busted jvm symlinks' do
  command %w[
    rm -f
    /usr/lib/jvm/default-java
    /usr/lib/jvm/java-8-oracle-amd64
    /usr/lib/jvm/.java-8-oracle-amd64.jinfo
  ].join(' ')
  action :nothing
end

log 'trigger jvm symlink cleanup' do
  level :info
  notifies :run, 'execute[clean up busted jvm symlinks]'
end

log 'trigger setting default java' do
  level :info
  notifies :run, "execute[set #{default_jvm} as default alternative]"
  not_if { default_jvm.nil? }
end
