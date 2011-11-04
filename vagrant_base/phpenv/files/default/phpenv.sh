#!/bin/sh

export PATH=$PATH:$HOME/.phpenv/bin
eval "$(phpenv init -)"
phpenv rehash 2>/dev/null
