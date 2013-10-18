#
# This recipe and related oraclejdk<V> recipes rely on a PPA package and is Ubuntu/Debian specific.
# Please keep this in mind.
#

package "debconf-utils"
package "curl"

apt_repository "webupd8team-java-ppa" do
  uri          "http://ppa.launchpad.net/webupd8team/java/ubuntu"
  distribution node['lsb']['codename']
  components   ["main"]
  key          "EEA14886"
  keyserver    "keyserver.ubuntu.com"

  action :add
end
