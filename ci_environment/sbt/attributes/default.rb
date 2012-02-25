# 5 minutes to install sbt's own dependencies under ~/.sbt/boot. MK.
default[:sbt][:boot][:timeout]   = 300

default[:sbt][:scala][:versions] = ["2.9.1", "2.9.0-1", "2.8.2", "2.8.1"]
