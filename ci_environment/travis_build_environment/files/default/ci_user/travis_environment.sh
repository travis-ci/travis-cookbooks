# Debian tools should not expect interactive keyboard input
# (like y/n confirmations)
export DEBIAN_FRONTEND=noninteractive

export CI=true
export TRAVIS=true

# without this magic variable, nothing can possibly work. MK.
export HAS_JOSH_K_SEAL_OF_APPROVAL=true
# http://www.youtube.com/watch?v=QPPN_gkj_gk
export HAS_ANTARES_THREE_LITTLE_FRONZIES_BADGE=true

export RAILS_ENV=test
export MERB_ENV=test
export RACK_ENV=test

# http://getcomposer.org/doc/03-cli.md#composer-no-interaction
export COMPOSER_NO_INTERACTION=1

# --client for older OpenJDK C1 compiler, with faster startup
#
# -J-XX:+TieredCompilation  To enable the equivalent of the C1 compiler on
# -J-XX:TieredStopAtLevel=1 newer versions of OpenJDK
#
# -Xcext.enabled=false to disable C extensions, running them in production
#                      on JRuby is a bad idea but developers often have no
#                      clue they depend on C extensions
#
# -J-Xss2m bumps stack size to 2 MB
#
# -Xcompile.invokedynamic=false disables invokedynamic which is still somewhat experimental
export JRUBY_OPTS="--client -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1 -Xcext.enabled=false -J-Xss2m -Xcompile.invokedynamic=false"
