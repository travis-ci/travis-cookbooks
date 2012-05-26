#!/bin/sh

# if jdk_switcher is provisioned (typically part of java::multi recipe),
# export JAVA_HOME to use the default JDK
if test -x $(which jdk_switcher); then
    export JAVA_HOME=$(jdk_switcher home default)
fi
