user = "travis"

default[:travis_build_environment] = {}
default[:travis_build_environment][:user] = user
default[:travis_build_environment][:group] = node.travis_build_environment.user
default[:travis_build_environment][:home] = "/home/#{node.travis_build_environment.user}"
default[:travis_build_environment][:hosts] = Hash.new
default[:travis_build_environment][:update_hosts] = true
default[:travis_build_environment][:builds_volume_size] = "350m"
default[:travis_build_environment][:use_tmpfs_for_builds] = true
default[:travis_build_environment][:installation_suffix] = "org"
default[:travis_build_environment][:apt] = {
  # in seconds
  :timeout => 10,
  :retries => 2
}
default[:travis_build_environment][:arch] = (kernel['machine'] =~ /x86_64/ ? "amd64" : "i386")
