neo4j_version = "1.8"

default[:neo4j][:server] = {
  :version => neo4j_version,
  :installation_dir => "/usr/local/neo4j-server",
  :tarball => {
    :url => "http://dist.neo4j.org/neo4j-community-#{neo4j_version}-unix.tar.gz",
    :md5 => "7a76a75bac1a32c5291e8e7b238f7ca2"
  },
  :user => "neo4j",
  :jvm  => {
    :xms => 32,
    :xmx => 512
  },
  :limits => {
    :memlock => 'unlimited',
    :nofile  => 48000
  },
  # needed only to recursively change permissions. Don't forget to update this
  # when you change :data_dir location!
  :lib_dir   => "/var/lib/neo4j-server/",
  :data_dir  => "/var/lib/neo4j-server/data/graph.db",
  :conf_dir  => "/usr/local/neo4j-server/conf",
  :lock_path => "/var/run/neo4j-server.lock",
  :pid_path  => "/var/run/neo4j-server.pid",
  :http => {
    :port     => 7474
  },
  :https => {
    :enabled => true
  },
  :plugins => {
    :spatial => {
      :enabled => true,
      :url => "https://github.com/downloads/goodwink/neo4j-server-chef-cookbook/neo4j-spatial-0.9-SNAPSHOT-server-plugin.zip",
      :version => "0.9-SNAPSHOT",
      :md5 => "65e6d30e856f191a20f3f6e78eaaf5a7"
    }
  },
  :service => {
    :enabled => false
  }
}
