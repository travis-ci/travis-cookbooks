# On Ubuntu 12.04, there are some package conflicts between 'tzdata', 'tzdata-java' and opendjdk packages.
# TODO: check if these workarounds are still needed on an updated 12.04.x or in later releases...
#
# See also:
# - https://github.com/travis-ci/travis-cookbooks/commit/65b0ecaaf04b1a60bc463077222a1e046391f333
# - https://bugs.launchpad.net/ubuntu/+source/openjdk-6/+bug/1052900
# - https://bugs.launchpad.net/ubuntu/+source/openjdk-6/+bug/1047762

package 'tzdata' do
  version '2012b-1'
  options '--force-yes'
  only_if do
    %w(ubuntu debian).include?(node['platform']) &&
      node['lsb']['release'] == 'precise'
  end
end

package %w(
  icedtea-6-plugin
  openjdk-6-jdk
  openjdk-6-jre-headless
  tzdata-java
)
