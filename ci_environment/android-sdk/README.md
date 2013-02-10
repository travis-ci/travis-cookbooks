Description
-----------

This cookbook will install [Google Android SDK](http://developer.android.com/sdk/index.html).

The **default** recipe of this Chef cookbook will:

* Download and install/upgrade Android SDK (not ADT)
* Update SDK dependencies to install all available Android platforms
* Define a default `ANDROID_HOME` environment variable (via `/etc/profile.d/...` mechanism)
* Add `ANDROID_HOME/tools` and `ANDROID_HOME/platform-tools` to default `PATH` environment variable (via `/etc/profile.d/...` mechanism)

Requirements
------------

* Depends on **opscode/java** cookbook
* This cookbook is intentionally designed to only run on Linux/i386 platform, but NOT on Linux/x86_64. See https://github.com/travis-ci/travis-worker/issues/56 and https://github.com/travis-ci/travis-cookbooks/pull/137#issuecomment-12410581 for more details.

Attributes
----------

TODO

Installation and Usage
----------------------

* Find your favourite way ([Berkhelf](http://berkshelf.com/), [Librarian-Chef](https://github.com/applicationsonline/librarian#readme), knife-github-cookbooks, Git submodule, Opscode community API or even tarball download) to install this cookbook (and its dependency).
* Include the `android-sdk::default` recipe to your run list or inside your cookbook.
* Provision!

License
-------

* Copyright:: 2013, Travis CI Development Team <contact@travis-ci.org>
* Authors::   Gilles Cornu

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
