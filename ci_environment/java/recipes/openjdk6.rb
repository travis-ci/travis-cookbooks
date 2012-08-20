version = 6

pkgs = value_for_platform(["centos","redhat","fedora","scientific","amazon"] => {
                            "default" => ["java-1.#{version}.0-openjdk","java-1.#{version}.0-openjdk-devel"]
                          },
                          ["arch","freebsd"] => {
                            "default" => ["openjdk#{version}"]
                          },
                          "default" => ["tzdata-java",
                                        "openjdk-#{version}-jre-headless",
                                        "openjdk-#{version}-jdk"])

case node.platform
when "ubuntu", "debian"
  if node.platform_version.to_f >= 12.04
    package "tzdata" do
      version "2012b-1"
      options "--force-yes"
    end
  end
end

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end
