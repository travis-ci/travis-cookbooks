include_attribute 'travis_build_environment'

default['android-sdk']['maven-android-sdk-deployer']['name']            = "maven-android-sdk-deployer"
default['android-sdk']['maven-android-sdk-deployer']['version']         = "881915c628650cbc275eaa111ce8e715016f43b2"
default['android-sdk']['maven-android-sdk-deployer']['git_repository']  = "https://github.com/mosabua/maven-android-sdk-deployer.git"

# TODO explain/verify why I don't want to be depending on
# Maven cookbook attributes (e.g. use node['maven']['mavenrc']['opts'])
default['android-sdk']['maven-local-repository']                        = File.join(node['travis_build_environment']['home'], %w(.m2 repository))
