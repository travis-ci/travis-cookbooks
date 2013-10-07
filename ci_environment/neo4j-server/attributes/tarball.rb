default[:neo4j][:server] = {
  :version => "1.9.4",
  :installation_dir => "/usr/local/neo4j-server",
  :tarball => {
    :url => nil, # This can be manually set by the user.
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
    :host     => "0.0.0.0",
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
  :node_auto_indexing => {
    :enabled => false,
    :keys_indexable => ''
  }
}
