name             "travis_go_worker"
maintainer       "Travis CI"
maintainer_email "contact@travis-ci.com"
license          "MIT"
description      "Installs/Configures the Travis Go Worker"
version          "0.0.1"

%w{ packagecloud }.each do |cb|
  depends cb
end
