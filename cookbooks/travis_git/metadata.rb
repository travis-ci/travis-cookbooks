name              "travis_git"
maintainer        "Travis CI GmbH"
maintainer_email  "contact+travis-cookbooks-git@travis-ci.org"
license           "Apache 2.0"
description       "Installs git and/or sets up a Git server daemon, forked from Opscode git 0.9.0"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.9.0"
recipe            "git", "Installs git"

%w{ ubuntu debian arch}.each do |os|
  supports os
end

%w{ runit apt }.each do |cb|
  depends cb
end
