#!/bin/sh

# if jdk_switcher is provisioned (typically part of java::multi recipe),
# export JAVA_HOME to use the default JDK
if test -f $HOME/.jdk_switcher_rc; then
    . $HOME/.jdk_switcher_rc
    jdk_switcher use default
fi
