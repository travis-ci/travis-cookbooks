Description
-----------

This cookbook is designed to install several versions of PostgreSQL for Continuous Integration purpose, and currently only supports Ubuntu 12.04LTS platform.

The **default** recipe of this Chef cookbook will:

* Add PGDG apt repository
* Install a default PostgreSQL version from PGDG repository (e.g. 9.1)
* Install alternate PostgreSQL versions from PGDG repository (e.g. 9.2 and 9.3). Note that all PostgreSQL instances are configured to listen on the same tcp port. (optional)
* Create additional superusers in all available PostgreSQL instances (optional)
* Override `/etc/init.d/postgresql` script to ensure that only one instance is running at the same time
* Use RAMFS storage to reduce I/O impact (optional)
* Tune some `postgresql.conf` parameters for performance optimization in a CI context (e.g. disable `fsync` data safety) (optional)
* include **postgis** recipe to:
 * Add ubuntugis-stable PPA to backport libgdal1 (>= 1.9.0) on Ubuntu 12.04
 * Install the same PostGIS version from PGDG repository (e.g. 2.1) to all PostgreSQL instances (optional). Attention some combinations are not supported (e.g. PostGIS 2.1/PostgreSQL 8.4 or PostGIS 2.0/PostgreSQL 9.3)

If you look for a more *"standard"* installation (e.g. for a productive database server), the [Opscode Community Cookbook](http://community.opscode.com/cookbooks/postgresql) and genuine [PostgreSQL Global Development Group (PGDG) packages](https://wiki.postgresql.org/wiki/Apt) may better fit your needs.

License and Authors
-------------------

* Author:: Michael S. Klishin <michaelklishin@me.com>
* Author:: Gilles Cornu <foss@gilles.cornu.name>
* Copyright:: 2011-2013, Travis CI Development Team

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
