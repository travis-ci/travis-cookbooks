#!/bin/sh

# if jdk_switcher is provisioned (typically part of java::multi recipe),
# load it
if test -f $HOME/.jdk_switcher_rc; then
    . $HOME/.jdk_switcher_rc
fi
