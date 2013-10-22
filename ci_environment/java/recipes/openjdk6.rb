
#
# On Ubuntu 12.04, there are some package conflicts between 'tzdata', 'tzdata-java' and opendjdk packages.
# TODO: check if these workarounds are still needed on an updated 12.04.x or in later releases...
#
# See also:
# - https://github.com/travis-ci/travis-cookbooks/commit/65b0ecaaf04b1a60bc463077222a1e046391f333
# - https://bugs.launchpad.net/ubuntu/+source/openjdk-6/+bug/1052900
# - https://bugs.launchpad.net/ubuntu/+source/openjdk-6/+bug/1047762
#
case node.platform
when "ubuntu", "debian"
  if node.platform_version.to_f >= 12.04
    package "tzdata" do
      version "2012b-1"
      options "--force-yes"
    end
  end
end
package 'tzdata-java'


package 'openjdk-6-jre-headless'
package 'openjdk-6-jdk'
package 'icedtea-6-plugin'