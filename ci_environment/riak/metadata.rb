name              "riak"
maintainer        "Travis CI Team"
maintainer_email  "contact@travis-ci.org"
license           "Apache 2.0"
description       "Installs Riak from packagecloud and configures it for Continuous Integration"
version           "3.0.0"

recipe            "riak::default", "Install Riak for a CI environment"

depends           'apt'

%w{ubuntu, debian}.each do |os|
  supports os
end

