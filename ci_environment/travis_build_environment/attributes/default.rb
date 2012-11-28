user = "travis"

default[:travis_build_environment] = {
  :user                 => user,
  :group                => user,
  :home                 => "/home/#{user}",
  :hosts                => Hash.new,
  :builds_volume_size   => "350m",
  :use_tmpfs_for_builds => true,
  # "org" or "com"
  :installation_suffix  => "org",

  :apt                  => {
    # in seconds
    :timeout => 10,
    :retries => 2
  },

  :arch => (kernel['machine'] =~ /x86_64/ ? "amd64" : "i386")
}
