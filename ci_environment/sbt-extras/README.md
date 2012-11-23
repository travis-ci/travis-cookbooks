Description
-----------

This cookbook will install [sbt-extras](https://github.com/paulp/sbt-extras), an alternative script for running [sbt](https://github.com/harrah/xsbt). sbt-extras works with sbt 0.7.x projects as well as 0.10+. If you're in an sbt project directory, the runner will figure out the versions of sbt and scala required by the project and download them if necessary.

The **default** recipe of this Chef cookbook will:

* Download and install the sbt-extras script (e.g. from a github commit/branch/tag) 
* Potentially grant some (or even all) users to download/install on demand the required sbt/scala versions.
* Optionally deploy some system-wide configuration files (`/etc/sbt/sbtopts` and `/etc/sbt/jvmopts`)
* Optionally trigger the installation of some sbt/scala dependencies for specific users (see the *'Optional Attributes'* section below)

Requirements
------------

* Depends on **opscode/java** cookbook
* Conflicts with **gildegoma/typesafe-stack** cookbook

Attributes
----------

* `node['sbt-extras']['download_url']` - URL to obtain a specific version of sbt-extras script. 
  * **Note:** we currently refer to an sbt-extras fork version, in order to get **/etc**-style default config files, which is not (yet) a standard feature. See related [pull request](https://github.com/paulp/sbt-extras/pull/36) ...
  * `node['sbt-extras']['default_sbt_version']` - non-DRY attribute introduced to improve idempotence of default recipe. Such parameter should always match with the default sbt version of sbt-extra script currently installed.
* `node['sbt-extras']['setup_dir']` - Target directory for installation (default: `/opt/sbt-extras`)
* `node['sbt-extras']['script_name']` - Name of the installed script (default: `sbt`).
* `node['sbt-extras']['bin_symlink']` - (optional) sbt-extras script will be linked from this location, *only if this attribute is defined!* (enabled by default to: `/usr/bin/sbt`)
* `node['sbt-extras']['owner']` - user owner of installed resources (default: `root`)
* `node['sbt-extras']['group']` - group owner of installed resources (default: `sbt`). **Important:** Members of this group are granted to auto-download/setup on demand any missing versions of sbt (setgid flag is set on `node['sbt-extras']['setup_dir']/.lib` and download files are ``002` umasked.
* `node['sbt-extras']['group_new_members']` - Members of `node['sbt-extras']['group']`, *to be appended if the group already exists*.
* `node['sbt-extras']['sbtopts']['mem']` - sbt-extras `-mem <mem>` is used when executing sbt script during chef provisioning. This parameter is also used when installing `/etc/sbt/sbtopts` template (see below)
* `node['sbt-extras']['config_dir']` - Target directory for global configuration files (default: `/etc/sbt`). The default recipe can potentially install 2 templates in this directory if their filename attribute is not empty (`''`)
  * `node['sbt-extras']['sbtopts_filename']` - default sbt arguments can be globally set in this file (default: `sbtopts`)
  * `node['sbt-extras']['jvmopts_filename']` - default jvm arguments can be globally set in this file (disabled by default: `''`, recommended name is `jvmopts`)
* `node['sbt-extras']['preinstall_cmd']['timeout']` - timeout value when executing sbt to download 'boot' dependencies (default: `300` - 5 minutes)
* `node['sbt-extras']['preinstall_matrix'][<user_name>][<array of sbt versions>]` - (optional) **user/sbt-versions** matrix to pre-install in `~/.sbt` during chef provisioning. Examples: 

```ruby
node['sbt-extras']['preinstall_matrix']['scala_lover'] = %w{ 0.12.1 0.12.0 0.11.3 0.11.2 0.11.1 }
node['sbt-extras']['preinstall_matrix']['sbt_tester'] = %w{ 0.12.1-RC2 0.12.1-RC1 }
``` 

Installation and Usage
----------------------

* Find your favourite way (Librarian-Chef, knife-github-cookbooks, Git submodule, Opscode community API or even tarball download) to install this cookbook (and its dependency). **[Librarian](https://github.com/applicationsonline/librarian#readme) is a very nice cookbook bundler!**
* Include the `sbt-extras::default` recipe to your run list or inside your cookbook.
* Provision!

Quality Assurance
-----------------

Cookbook is frequently being _tasted_ by:

* a [foodcritic](http://acrmp.github.com/foodcritic/)
* Ubuntu 12.10 64-bit, ChefSolo 10.16.2 and java cookbook 1.6.0 (openjdk)
* CentOS 6.3 64-bit, ChefSolo 10.14.2 and java cookbook 1.6.0 (openjdk)

How to Contribute
-----------------

*Feel free to open issues, fork repo and send pull request (based on a custom branch, not master)!*

License
-------

* Copyright:: 2012, Gilles Cornu

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
