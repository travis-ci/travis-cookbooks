Current:

- Updated Clang to 3.4 (Gilles Cornu)

- Updated ark cookbook to v0.7.2 with additional patch [COOK-2771] for support of XZ compression (Gilles Cornu)

- Updated ElasticSearch to 1.1.0 (Gilles Cornu)

- Updated Maven to 3.2.1 (Gilles Cornu)

- Integrated new cookbook: android-sdk v0.2.0 (Gilles Cornu)

- Updated sbt-extras to 60b6f267d47e8dd915a3baaef3b0b63fef37e5dd (Gilles Cornu)

- Added JCE Unlimited Strength Jurisdiction Policy Files to Oracle JDK 8 (Gilles Cornu)

- Updated Phantom Js to 1.9.7

- Updated Rebar download location (Chase James, Michael Klishin)

- Updated PHP to 5.4.27 and 5.5.11 (Graham Campbell and Loïc Frering)

- Support for PHP 5.6 with 5.6.0alpha3 (Loïc Frering)

- Updated HHVM to 3.0.1 (Graham Campbell and Loïc Frering)

- Support for HHVM nightly (Loïc Frering)

Production .org 03.01.2014

- Update Perl versions to 5.17.11, 5.18.1 and 5.19.6 (Henrik Hodne)

- Added Erlang R16B03, R16B03-1 and 17.0-rc1 (Michael Klishin and José Valim)

- Updated Cassandra to 2.0.4 (Michael Klishin)

- Updated ElasticSearch to 0.9.10 (Ray Ward)

- Update Gradle to 1.10 (Michael Klishin)
 
- Updated Node.js to 0.10.25 and 0.11.11 (Josh Kalderimis)

- Updated PHP to 5.4.24 and 5.5.8 (Loïc Frering)

- Updated HHVM to 2.4.0 (Loïc Frering)

- Upgraded Virtualenv to 1.11.1 (Alex Gaynor)

Production .org 10.12.2013

- Fix rvm warning that a Ruby version can't be found even though it's available (Josh Kalderimis)

- Update Redis to 2.8.2 (currently only on the Ruby, PHP and JVM images) (Josh Kalderimis)

- Raise PHP memory limit to 1GB (Loïc Frering)

- Add Go 1.2 to preinstalled versions (Mathias Meyer)

- Download Cassandra from Apache archive (Michael Klishin)

Production .org and .com 29.11.2013:

- Update RVM to 1.24.5 (Josh Kalderimis)
  This will include updated checksums for Ruby 1.9.3 (p484) and changes to
  how RBX is selected.

- Update Leiningen to 2.3.4 (Michael Klishin)

- Update Ruby 1.9.3-p484 and 2.0.0-p353 (Josh Kalderimis)

- Update Node.js 0.11 branch to 0.11.9 (Josh Kalderimis)

- Update Cassandra to 2.0.3 (Josh Kalderimis)

- Update Gradle to 1.9 (Michael Klishin)

- Update Cassandra configurations for 2.0.2 (#242, Mathias Meyer)
  The last update broke Cassandra completely by using older versions of the
  configurations. This change removes any special cases, as 2.0.2 runs just fine
  on our default stack with IPv4 now.
