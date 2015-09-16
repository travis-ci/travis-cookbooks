Description
===========

Configures and installs JPackage.  Used to install Java-related packages on Red Hat flavored linuxes

The JPackage Project has two primary goals:

* To provide a coherent set of Java software packages for Linux, satisfying all quality requirements of other applications.
* To establish an efficient and robust policy for Java software packaging and installation.

Requirements
============

Chef 0.10.10 and Ohai 0.6.12 are required due to the use of
`platform_family`.

Platform: 

* CentOS, Red Hat, Amazon, Oracle, Scientific, Fedora

The following Opscode cookbooks are dependencies:

* java

Attributes
==========

* `node["jpackage"]["version"]` - The JPackage version to install, default "5.0".

Usage
=====

Simply include the recipe where you want JPackage installed.

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
