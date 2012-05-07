default[:sbt] = {
  :version => "0.11.3",
  :boot => {
    # 5 minutes to install sbt's own dependencies under ~/.sbt/boot. MK.
    :timeout => 300
  },
  :scala => {
    :versions => ["2.9.2", "2.9.1", "2.9.0-1", "2.8.2", "2.8.1"]
  }
}
