maintainer "James Harton, Sociable Limited."
maintainer_email "james@sociable.co.nz"
license "MIT"
description "Installs and configures RVM, optionally keeping it updated."
version "0.0.2"

# The rvm recipe only installs rvm
# and doesn't do anything else.
recipe "rvm", "Install system-wide RVM"
# the rvm:install recipe installs
# a ruby implementation based on
# node attributes.
recipe "rvm::install", "Install a ruby implementation based on attributes"

# these are just quick helpers
# for common implementations for
# people who can't/won't set
# node attributes for themselves.
recipe "rvm::ruby_192", "Helper recipe to install ruby 1.9.2"
recipe "rvm::ruby_187", "Helper recipe to install ruby 1.8.7"
recipe "rvm::ree", "Helper recipe to install ruby enterprise edition"

depends "apt"
depends "build-essential"
