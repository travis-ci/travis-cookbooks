maintainer       "Travis CI Development Team"
license          "Apache v2.0"
description      "Installs/Configures maven3"

%w{ java jpackage }.each do |cb|
  depends cb
end