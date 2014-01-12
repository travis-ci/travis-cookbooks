cassandra_version = "2.0.4"

default[:cassandra] = {
  :version => cassandra_version,
  :tarball => {
    :url => "http://archive.apache.org/dist/cassandra/#{cassandra_version}/apache-cassandra-#{cassandra_version}-bin.tar.gz",
    :md5 => "4c7c7620056ed436cd4d3c0756d02761"
  },
  :user => "cassandra",
  :jvm  => {
    :xms => 32,
    :xmx => 512
  },
  :limits => {
    :memlock => 'unlimited',
    :nofile  => 48000
  },
  :installation_dir => "/usr/local/cassandra",
  :bin_dir          => "/usr/local/cassandra/bin",
  :lib_dir          => "/usr/local/cassandra/lib",
  :conf_dir         => "/usr/local/cassandra/conf",
  # commit log, data directory, saved caches and so on are all stored under the data root. MK.
  :data_root_dir    => "/var/lib/cassandra/",
  :log_dir          => "/var/log/cassandra/",
  :ipv6             => true,
  :service          => {
    :enabled => false
  }
}
