# CHANGELOG for sbt-extras cookbook

## 0.3.0

* The way to refer to global configuration files has changed, see https://github.com/paulp/sbt-extras/pull/43
* Default recipe is far simpler as in 0.2.x!* (no more group sid trick, no more shared libraries between user installations,...)
* Preinstallation of sbt and scala boot libraries has been strongly improved

* [GH-15]: Test-Kitchen testing is (partly) supported
* [GH-17]: Ready to integrate with paulp/sbt-extras (but still pending that [`-batch` bug is fixed](https://github.com/paulp/sbt-extras/pull/62))
* [GH-18]: Clean sbtopts and jvmopts templates

## 0.2.2

* [GH-4]: default recipe is now 100% idempotent
* [GH-5]: User/SBT pre-installation is now coherent and support 0.12 and 0.11 generations.

## 0.2.1

* *administrative* release that only re-packaged 0.2.0, but without unwanted files ('~' backups, .gitignore,...)

## 0.2.0

* [GH-3]: *Optional* templates for global config files (/etc/sbt/sbtopts and /etc/sbt/jvmopts)
* Attributes modified (not backward compatible with 0.1.0)
* Added timeout on 'execute' resources (sbt/scala downloads)

## 0.1.0

* Initial release
