name              "riak"
maintainer        "Travis CI Team"
maintainer_email  "contact@travis-ci.org"
license           "Apache 2.0"
description       "Installs Riak from apt.basho.com and configure it for Continuous Integration purpose"
version           "2.0.0"

recipe            "riak::default", "Install Riak for a CI environment"

supports          'ubuntu', '= 12.04'

depends           'apt'

