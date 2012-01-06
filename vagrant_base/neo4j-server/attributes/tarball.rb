default[:neo4j][:server] = {
  :version => "1.6.M02",
  :installation_dir => "/usr/local/neo4j-server",
  :tarball => {
    :url => "http://dist.neo4j.org/neo4j-community-1.6.M02-unix.tar.gz",
    :md5 => "d90e08da7de51d3c56b56688a731fc7a"
  },
  :user => "neo4j",
  :jvm  => {
    :xms => 32,
    :xmx => 512
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
  }
}
