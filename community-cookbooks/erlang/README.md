Description
===========

Manages installation of Erlang via packages or source.

Requirements
============

## Chef

Chef version 0.10.10+ and Ohai 0.6.12+ are required

## Platform

Tested on:

* Ubuntu 10.04, 11.10, 12.04, 14.04
* Red Hat Enterprise Linux (CentOS/Amazon/Scientific/Oracle) 5.11, 6.6

**Notes**: This cookbook has been tested on the listed platforms. It may work on other platforms with or without modification.

## Cookbooks

* yum (for epel recipe)
* build-essential (for source compilation)

Attributes
==========

* `node['erlang']['gui_tools']` - whether to install the GUI tools for
  Erlang.
* `node['erlang']['install_method']` - Erlang installation method
  ("package", "source", or "esl" (for Erlang Solutions packages)).
* `node['erlang']['source']['version']` - Version of Erlang/OTP to install from source.
  "source")
* `node['erlang']['source']['url']` - URL of Erlang/OTP source tarball.
* `node['erlang']['source']['checksum']` - Checksum of the Erlang/OTP source tarball.
* `node['erlang']['source']['build_flags']` - Build flags for compiling Erlang/OTP.
* `node['erlang']['source']['cflags']` - CFLAGS for configuring Erlang/OTP.
* `node['erlang']['esl']['version']` - version specifier for Erlang
  Solutions packages.
* `node['erlang']['esl']['lsb_codename']` - override the code name
  used for ESL packages, useful for installing the packages on
  distributions that they don't make specific packages available
  (e.g., maverick vs precise).

Recipes
=======

## default

Manages installation of Erlang. Includes the package or source recipe
depending on the value of `node['erlang']['install_method']`.

## package

Installs Erlang from distribution packages.

## source

Installs Erlang from source.

## erlang_solutions

Adds Erlang Solutions' [package repositories][] on Debian, CentOS (>5), and Fedora systems, and installs the `esl-erlang` package.

[package repositories]:https://www.erlang-solutions.com/downloads/download-erlang-otp

License and Author
==================

* Author: Joe Williams (<joe@joetify.com>)
* Author: Joshua Timberman (<joshua@chef.io>)
* Author: Matt Ray (<matt@chef.io>)
* Author: Hector Castro (<hector@basho.com>)
* Author: Christopher Maier (<cm@chef.io>)

Copyright 2011-2015, Chef Software, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
