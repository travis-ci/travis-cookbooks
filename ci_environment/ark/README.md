# <a name="title"></a> chef-ark [![Build Status](https://secure.travis-ci.org/bryanwb/chef-ark.png?branch=master)](http://travis-ci.org/bryanwb/chef-ark)

Overview        
========

An ''ark'' is like an archive but ''Kewler''

Does the fetch-unpack-configure-build-install dance. This is a
modified  verion of Infochimps awesome install_from cookbook
 [http://github.com/infochimps-cookbooks/install_from]. It has been
 heavily refactored and extended to meet different use cases.

Given a project `pig`, with url `http://apache.org/pig/pig-0.8.0.tar.gz`, and
the default :path of `/usr/local`, this provider will

* fetch  it to to `/var/cache/chef/`
* unpack it to :path  (`/usr/local/pig-0.8.0`)
* create a symlink for :home_dir (`/usr/local/pig`) pointing to :path
* add specified binary commands to the enviroment PATH variable

By default, the ark will not run again if the :path is not
empty. Ark provides many actions to accommodate different use cases,
such as :dump, :cherry_pick, :put, and :install_with_make.

At this time ark only handles files available from URLs. It does not
handle local files.


Attributes
==========

You can customize the basic attributes to meet your organization's conventions

* default[:ark][:apache_mirror] = 'http://apache.mirrors.tds.net'


Resources/Providers
===================

* ark - does the extract/build/configure dance

Actions 
=======

- :install: extracts the file and creates a 'friendly' symbolic link
  to the extracted directory path
- :configure: configure ahead of the install action
- :install_with_make: extracts the archive to a path, runs make, and
  make install. It does _not_ run the configure step at this time
- :dump: strips all directories from the archive and dumps the
  contained files into a specified path
- :cherry_pick: extract a specified file from an archive and places
  in specified path
- :put: extract the archive to a specified path, does not create any
  symbolic links
- :remove: removes the extracted directory and related symlink #TODO
- :setup_py_build: runs the command "python setup.py build" in the
  extracted directory
- :setup_py_install:  runs the comand "python setup.py install" in the
  extracted directory

# :put

## Relevant Attribute Parameters

- path: path to extract to, defaults to '/usr/local'
- has_binaries: array of binary commands to symlink to
  /usr/local/bin/, you must specify the relative path example: [ 'bin/java', 'bin/javaws' ]
- append_env_path: boolean, if true, append the ./bin directory of the
  extracted directory to the global PATH variable for all users

# :dump


NOTE: This currently only works for zip archives

## Relevant Attribute Parameters

- path: path to dump files to 
- mode: file mode for app_home, is an integer
- creates: if you are appending files to a given directory, ark
  needs a condition to test whether the file has already been
  extracted. You can specify with creates, a file whose existence
  indicates the ark has previously been extracted and does not need to
  be extracted again

# :cherry_pick


## Relevant Attribute Parameters

- path: directory to place file in
- creates: specific file to cherry-pick


ark
===

# Attribute Parameters

- name: name of the package, defaults to the resource name
- url: url for tarball, .tar.gz, .bin (oracle-specific), .war, and .zip
  currently supported. Also supports special syntax
  :name:version:apache_mirror: that will auto-magically construct
  download url from the apache mirrors site
- version: software version, defaults to "1" if not specified. The :dump, :cherry_pick, and :put actions do not use it
- extension: The file extension of the file you are trying to
  download. If not specified, ark tries to determine the file
  extension by parsing the URL
- checksum: sha256 checksum, used for security 
- mode: file mode for app_home, is an integer TODO
- prefix_root: default prefix_root, for use with :install* actions
- prefix_home: default directory prefix for a friendly symlink to the path, for
  example  /usr/local/maven -> /usr/local/maven-2.2.1
- prefix_bin: default directory to place a symlink to a binary
  command, example /opt/bin/mvn ->
  /opt/maven-2.2.1/bin/mvn , where the prefix_bin is "/opt/bin"
- path: path to extract the ark to, by default is
  /usr/local/<name>-<version> for the :install, :install_with_make actions
  the :install* actions overwrite any user-provided values for :path
- home_dir: symbolic link to the path :prefix_root/:name-:version,
  defaults to :prefix_root/:name , , does not apply to :dump, :put, or
  :cherry_pick actions
- has_binaries: array of binary commands to symlink to
  /usr/local/bin/, you must specify the relative path example: [ 'bin/java', 'bin/javaws' ]
- append_env_path: boolean, similar to has_binaries but less granular
  - If true, append the ./bin directory of the extracted directory to
  the PATH environment  variable for all users, does this by placing a file in /etc/profile.d/ which will be read by all users
  be added to the path. The commands are symbolically linked to
  /usr/bin/* . Examples are mvn, java, javac, etc. This option
  provides more granularity than the boolean option
- environment: hash of environment variables to pass to invoked shell
  commands like tar, unzip, configure, and make
- strip_leading_dir: by default, ark strips the leading directory from
  an archive, which is the default for both unzip and tar commands 
- autoconf_opts: an array of command line options for use with the GNU
  autoconf script
- make_opts: an array of command line options for use with make
- owner: owner of extracted directory, set to "root" by default

# Examples

     # install Apache Ivy dependency resolution tool
     ark "ivy" do
       url 'http://someurl.example.com/ivy.tar.gz'
       version '2.2.0'        
       checksum '89ba5fde0c596db388c3bbd265b63007a9cc3df3a8e6d79a46780c1a39408cb5'
       action :install
     end
    
This example copies ivy.tar.gz to /var/cache/chef/ivy-2.2.0.tar.gz,
unpacks its contents to /usr/local/ivy-2.2.0/ -- stripping the
leading directory, and symlinks /usr/local/ivy to /usr/local/ivy-2.2.0


     ark 'jdk' do
       url 'http://download.example.com/jdk-7u2-linux-x64.tar.gz'
       version '7.2'
       path "/usr/local/jvm/"
       home_dir "/usr/local/jvm/default" 
       checksum  '89ba5fde0c596db388c3bbd265b63007a9cc3df3a8e6d79a46780c1a39408cb5'
       append_env_path true
       owner 'foobar'
     end

This example copies jdk-7u2-linux-x64.tar.gz to /var/cache/chef/jdk-7.2.tar.gz,
unpacks its contents to /usr/local/jvm/jdk-7.2/ -- stripping the
leading directory, symlinks /usr/local/jvm/default to
/usr/local/jvm/jdk-7.2, and adds /usr/local/jvm/jdk-7.2/bin/ to
the global PATH for all users. The user 'foobar' is the owner of the
/usr/local/jvm/jdk-7.2 directory

     # install Apache Ivy dependency resolution tool
     # in <path>/resource_name in this case
     # /usr/local/ivy, no symlink created
     # it strips any leading directory if one exists in the tarball
     ark "ivy" do
        url 'http://someurl.example.com/ivy.tar.gz'
        checksum '89ba5fde0c596db388c3bbd265b63007a9cc3df3a8e6d79a46780c1a39408cb5'
        action :put
     end

     # install Apache Ivy dependency resolution tool
     # in /home/foobar/ivy 
     # it does strip any leading directory if one exists
     ark "ivy" do
       path "/home/foobar
       url 'http://someurl.example.com/ivy.tar.gz'
       checksum '89ba5fde0c596db388c3bbd265b63007a9cc3df3a8e6d79a46780c1a39408cb5'
       action :put
     end

     

     # strip all directories and dump files into path specified by 
     # the path attribute, you must specify the `creates` attribute
     # in order to keep the extraction from running every time
     # the directory path will be created if it doesn't already exist
     ark "my_jars" do
       url  "http://example.com/bunch_of_jars.zip"
       path "/usr/local/tomcat/lib"
       creates "mysql.jar"
       owner "tomcat"       
       action :dump
     end

     # extract specific files from a tarball, currently only handles
     # one named file
     ark 'mysql-connector-java' do
       url 'http://oracle.com/mysql-connector.zip'
       creates 'mysql-connector-java-5.0.8-bin.jar'
       path '/usr/local/tomcat/lib'
       action :cherry_pick
     end


     # build and install haproxy and use alternave values for
     # prefix_root, prefix_home, and prefix_bin
     ark "haproxy" do
       url  "http://haproxy.1wt.eu/download/1.5/src/snapshot/haproxy-ss-20120403.tar.gz"
       version "1.5"
       checksum 'ba0424bf7d23b3a607ee24bbb855bb0ea347d7ffde0bec0cb12a89623cbaf911'
       make_opts [ 'TARGET=linux26' ]
       prefix_root '/opt'
       prefix_home '/opt'
       prefix_bin  '/opt/bin'
       action :install_with_make
     end    

     # you can also pass multiple actions to ark and supply the file extension
     # in case the file extension can not be determined by the URL
     ark "test_autogen" do
       url 'https://github.com/zeromq/libzmq/tarball/master'
       extension "tar.gz"
       action [ :configure, :build_with_make ]
     end    


     
## License and Author

Author::                Philip (flip) Kromer - Infochimps, Inc(<coders@infochimps.com>)  
Author::                Bryan W. Berry (<bryan.berry@gmail.com>)  
Author::                Denis Barishev (<denis.barishev@gmail.com>)  
Copyright::             2011, Philip (flip) Kromer - Infochimps, Inc  
Copyright::             2012, Bryan W. Berry  
Copyright::             2012, Denis Barishev   


Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
