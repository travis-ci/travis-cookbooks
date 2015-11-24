name 'travis_timezone'
# maintainer 'James Harton'
# maintainer_email 'james@sociable.co.nz'
maintainer 'Travis CI GmbH'
maintainer_email 'contact+travis-cookbooks-travis-timezone@travis-ci.org'
license 'Apache 2.0'
description 'Configure the system timezone on Debian or Ubuntu.'
version '0.1.0'

%w(ubuntu debian).each do |os|
  supports os
end
