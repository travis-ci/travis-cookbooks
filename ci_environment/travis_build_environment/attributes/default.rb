default[:travis_build_environment] = {
  :user                 => "travis",
  :group                => "travis",
  :home                 => "/home/travis",
  :hosts                => Hash.new,
  :builds_volume_size   => "350m",
  :use_tmpfs_for_builds => true
}
