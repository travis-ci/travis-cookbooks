Description
===========

Installs and configures Apache Ant

Requirements
============

Platform:

* Debian, Ubuntu, CentOS, Red Hat, Fedora

The following Opscode cookbooks are dependencies:

* java
* ark

Attributes
==========

* `node['ant']['version']` -  defaults to 1.8.2
* `node['ant']['home']`- defaults to /usr/local/ant
* `node['ant']['url']` - the download url for the ant binary zip
* `node['ant']['checksum']` - the sha256 checksum for the ant binary
  zip downloaded in the url
* `node['ant']['install_method']` - the installation recipe to use,
  can be "package" (default) or "source".
* `node['ant']['libraries']` - a hash of libraries and their URLs
  installed with the "`ant_library`" LWRP in the `install_source`
  recipe. The hash is the form `{"library-name" =>
  "http://url.to.library.jar.file"}`

Resources/Providers
===================

## ant\_library

### Actions

* `:install` - (Default) Install the ant library specified.

### Attributes

* `name` - name of the library
* `url` - url where the jar for the library can be downloaded

### Examples

    ant_library "ant-contrib" do
      url "http://search.maven.org/remotecontent?filepath=ant-contrib/ant-contrib/1.0b3/ant-contrib-1.0b3.jar"
    end

Usage
=====

Simply include the recipe where you want Apache Ant installed.

Recipes
=======

ant::install_package
====================

Backwards compatible recipe for older users of the cookbook. Installs Ant, Ant-Contribs, and Ivy using your OS's
package manager.

ant::install_source
===================

Installs Ant using the `ark` resource and a URL for an Ant archive. Adds an $ANT_HOME to your environment.
Uses the `ant::library` LWRP to install optional Ant packages into the Ant installation's `lib` directory.

TODO
====

* plugin support
* global config template - /etc/ant/ant.conf

License and Author
==================

Author:: Seth Chisamore (<schisamo@opscode.com>)

Copyright 2010, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
