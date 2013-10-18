version = 7

pkgs = value_for_platform(
  ["centos","redhat","fedora","scientific","amazon"] => {
    "default" => ["java-1.#{version}.0-openjdk","java-1.#{version}.0-openjdk-devel"]
  },
  ["arch","freebsd"] => {
    "default" => ["openjdk#{version}"]
  },
  "default" => ["openjdk-#{version}-jdk"])



pkgs.each do |pkg|
  package pkg do
    action :install
  end
end
