cassandra_version = "1.2.2"

default[:cassandra] = {
  :version => cassandra_version,
  :tarball => {
    :url => "http://www.apache.org/dist/cassandra/#{cassandra_version}/apache-cassandra-#{cassandra_version}-bin.tar.gz",
    :md5 => "3ddca9d7eb1129b3975ad7ad1fa8e891"
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
  :conf_dir         => "/etc/cassandra/",
  # commit log, data directory, saved caches and so on are all stored under the data root. MK.
  :data_root_dir    => "/var/lib/cassandra/",
  :log_dir          => "/var/log/cassandra/",
  :service          => {
    :enabled => false
  }
}
