version = 7

pkgs = value_for_platform(
  ["centos","redhat","fedora","scientific","amazon"] => {
    "default" => ["java-1.#{version}.0-openjdk","java-1.#{version}.0-openjdk-devel"]
  },
  ["arch","freebsd"] => {
    "default" => ["openjdk#{version}"]
  },
  "default" => ["openjdk-#{version}-jdk"])

execute "update-java-alternatives" do
  alternative = "java-1.#{version}.0-openjdk-#{node.travis_build_environment.arch}"

  command "update-java-alternatives -s #{alternative}"
  returns [0,2]
  action :nothing
  only_if { platform?("ubuntu", "debian") }
end


pkgs.each do |pkg|
  package pkg do
    action :install
    notifies :run, resources(:execute => "update-java-alternatives")
  end
end
