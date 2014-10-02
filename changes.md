### Upcoming:

- Add Erlang 17.3 (Eric Meadows-Jönsson)

- Update nvm to 0.17.1 (Jordan Harband)

- Update PyPy to 2.4.0, now the default (Alex Gaynor)

- Update Go to 1.3.3, now the default (Hiro Asari)

- Update Node.js to 0.10.32 (Graham Campbell)

- Update hhvm to 3.3.0 (Graham Campbell)

- Update to PHP 5.4.33 and 5.5.17 (Graham Campbell)

- Added ssh.github.com to SSH known_hosts (Hiroki Yoshida)

- Upgraded to Leiningen 2.5.0 (Michael Klishin)

### Production .org on 05.09.2014

- Update PHP 5.6.0 (Graham Campbell)

- Update xdebug on PHP 5.3.3 and PHP 5.5.9 to 2.2.5 (Graham Campbell)

- Update rvm to 1.25.29 (Hiro Asari)
  See note below on JRuby 1.7.14

- Update JRuby to 1.7.14 (Hiro Asari)
  This is dictated by the point in time when the new images are created
  by travis-images.

- Update Perl's ExtUtils::MakeMaker on each installed Perl runtime (Hiro Asari)
  It is 6.98 as of this writing.

- Create Perl 5.18 and 5.20 with '-Duseithreads' compile-time flag (Hiro Asari)
  This coexits with '-Duseshrplib'.

### Production .org on 29.08.2014

- Preinstall Scala 2.9.2 to ease cross-build support (Gilles Cornu)

- Preinstall Scala 2.10.2 as workaround for https://github.com/sbt/sbt/issues/1439 (Gilles Cornu)

- Update preinstalled versions of Scala (2.11.2) and sbt (0.13.5) (Gilles Cornu)

- Update Firefox to 31.0esr (Hiro Asari)

- Update nvm to 0.13.1 (Jordan Harband)

- Disable `git` pager by default (Hiro Asari)

- Update Leiningen to 2.4.3 (Michael Klishin)

- Install libicu-dev (Hiro Asari)

- Update to Android SDK 23.0.2 (Hiro Asari)

- Added PHP 5.5.9 (Hiro Asari)

- Updated PHP to 5.3.29, 5.4.32, 5.5.16, and 5.6.0RC4 (Graham Campbell)

- Update maven to 3.2.3 (Hiro Asari)

- Update Sphinx to 2.2.3-beta and 2.1.9 (Hiro Asari)

- Update ElasticSearch to 1.3.2 (Hiro Asari)

- Update Go to 1.3.1 (Hiro Asari)

- Update Haskell platform to 2014.2.0.0, ghc to 7.8.3 (Hiro	Asari)

- Update Gradle to 2.0.0 (Roberto Tyley)

- Pin Oracle JDK 7 to 7u60, 8 to 8u5 (Hiro Asari)

### Production .org 30.07.2014

- Update to Android SDK 23 and various changes in cookbook (Gilles Cornu)
  Updates identifiers of pre-installed components, Accept any license, Install helper scripts in /usr/local/bin

- Install Git from git-core/ppa instead of pdoes/ppa (Josh Kalderimis)

- Update ElasticSearch to 1.1.1 (Mathias Meyer)

- Update nvm to 0.7.0 (Jordan Harband)
  Enables auto-`use` when running `nvm install` to easily install and
  select not installed versions of Node.js and support for `.nvmrc`

- Update PyPy to 2.3.0, make it the new default (Alex Gaynor)

- Update preinstalled Firefox to 24.5.0est (Mathias Meyer)

- Erlang has ODBC support enabled (Mathias Meyer)

- Updated ark cookbook to v0.8.2 (Gilles Cornu)

- Removed older versions of sbt and Scala (Gilles Cornu)
  This removes Scala 2.10.3, 2.10.2, 2.9.2 and sbt 0.13.0, 0.12.3, 0.12.2, 0.11.3 and 0.11.2

### Production .org 30.04.2014

- Updated virtualenv to 1.11.4 (Donald Stufft)

- Added Python 3.4.0 and updated to 2.6.9, 2.7.6, 3.2.5, 3.3.5 and PyPy to 2.2.1 (Donald Stufft)

- Use pyenv instead of deadsnakes to install Python (Donald Stufft)

- Updated nvm to 0.5.0 (Jordan Harband)

- Added Haskell GHC 7.8.2 (Dmitry Malikov)

- Updated Erlang to 17.0 (Jose Valim)

- Update Firefox to 24.0 (Mathias Meyer)

- Pre-install Scala 2.11.0 and sbt 0.13.2 (Gilles Cornu)

- Updated Gradle to 1.11 (Gilles Cornu)

- Updated Clang to 3.4 (Gilles Cornu)

- Updated ark cookbook to v0.7.2 with additional patch [COOK-2771] for support of XZ compression (Gilles Cornu)

- Updated ElasticSearch to 1.1.0 (Gilles Cornu)

- Updated Maven to 3.2.1 (Gilles Cornu)

- Added Android SDK 22.6.2 (Gilles Cornu)

- Updated sbt-extras to 60b6f267d47e8dd915a3baaef3b0b63fef37e5dd (Gilles Cornu)

- Added JCE Unlimited Strength Jurisdiction Policy Files to Oracle JDK 8 (Gilles Cornu)

- Updated Phantom Js to 1.9.7

- Updated Rebar download location (Chase James, Michael Klishin)

- Updated PHP to 5.4.27 and 5.5.11 (Graham Campbell and Loïc Frering)

- Support for PHP 5.6 with 5.6.0beta1 (Loïc Frering)

- Updated HHVM to 3.0.1 (Graham Campbell and Loïc Frering)

- Support for HHVM nightly (Loïc Frering)


### Production .org 03.01.2014

- Update Perl versions to 5.17.11, 5.18.1 and 5.19.6 (Henrik Hodne)

- Added Erlang R16B03, R16B03-1 and 17.0-rc1 (Michael Klishin and José Valim)

- Updated Cassandra to 2.0.4 (Michael Klishin)

- Updated ElasticSearch to 0.9.10 (Ray Ward)

- Update Gradle to 1.10 (Michael Klishin)

- Updated Node.js to 0.10.25 and 0.11.11 (Josh Kalderimis)

- Updated PHP to 5.4.24 and 5.5.8 (Loïc Frering)

- Updated HHVM to 2.4.0 (Loïc Frering)

- Upgraded Virtualenv to 1.11.1 (Alex Gaynor)


### Production .org 10.12.2013

- Fix rvm warning that a Ruby version can't be found even though it's available (Josh Kalderimis)

- Update Redis to 2.8.2 (currently only on the Ruby, PHP and JVM images) (Josh Kalderimis)

- Raise PHP memory limit to 1GB (Loïc Frering)

- Add Go 1.2 to preinstalled versions (Mathias Meyer)

- Download Cassandra from Apache archive (Michael Klishin)


### Production .org and .com 29.11.2013

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
