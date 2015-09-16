name              "hhvm"
maintainer        "Travis CI Development Team"
maintainer_email  "contact@travis-ci.org"
license           "Apache v2.0"
description       "Installs HHVM from the package repository provided by the HipHop VM team."
version           "0.1.0"

supports         "ubuntu"

recipe           "hhvm::package", "Installs HHVM from the package repository provided by the HipHop VM team."
recipe           "hhvm::default", "Includes hhvm::package."
