Current:

- Update Cassandra to 2.0.3 (Josh Kalderimis)

- Update Gradle to 1.9 (Michael Klishin)

- Update Cassandra configurations for 2.0.2 (#242, Mathias Meyer)
  The last update broke Cassandra completely by using older versions of the
  configurations. This change removes any special cases, as 2.0.2 runs just fine
  on our default stack with IPv4 now.
