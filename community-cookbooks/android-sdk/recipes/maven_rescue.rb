# TODO: decide which way we depend on maven (weak dependency, conditional include_recipe or always include_recipe?)
# include_recipe "maven"

maven_android_sdk_deployer_root = node['android-sdk']['setup_root'].to_s.empty? ? node['ark']['prefix_home'] : node['android-sdk']['setup_root']
maven_android_sdk_deployer_home = File.join(maven_android_sdk_deployer_root, node['android-sdk']['maven-android-sdk-deployer']['name'])

#
# Install Maven Android SDK Deployer from git repository
#
directory maven_android_sdk_deployer_home do
  user node['android-sdk']['owner']
  group node['android-sdk']['group']
  mode 00755
  action :create
end
git maven_android_sdk_deployer_home do
  repository node['android-sdk']['maven-android-sdk-deployer']['git_repository']
  revision node['android-sdk']['maven-android-sdk-deployer']['version']
  checkout_branch "deploy_#{node['android-sdk']['maven-android-sdk-deployer']['version']}"
  action :sync
  user node['android-sdk']['owner']
  group node['android-sdk']['group']
end

#
# Deploy Android SDK jar files to a Maven local repository
# TODO: improve the messy management of the maven repository location
#
# The following is a KISS approach that should generally work pretty well, but
# it could be nicer/safer to loop over node['android-sdk']['components'] and
# generate a more precise `mvn -pl component1,component2,... install` command.
#
# The problem: target names do not match 100% of the time (e.g. "extras/google-play-services" vs "extra-google-google_play_services")
#
execute 'Execute maven-android-sdk-deployer' do
  command "mvn clean install -Dmaven.repo.local=#{node['android-sdk']['maven-local-repository']} --fail-never -B"
  user node['android-sdk']['owner']
  group node['android-sdk']['group']
  cwd maven_android_sdk_deployer_home

  # FIXME: setting HOME might be required (if $HOME used in node['android-sdk']['maven-local-repository'],
  #        or if -Dmaven.repo.local is unset (default to ~/.m2/repository)
  # environment   ({ 'HOME' => '/home/vagrant' })

  # Note: There is no idempotent guard for now. Pending on https://github.com/gildegoma/chef-android-sdk/issues/12.
end
