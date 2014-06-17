#!/bin/bash

set -e

if [ -n "$PHP_BUILD_DEBUG" ]; then
    set -x
fi

pear="$PREFIX/bin/pear"

if "$PREFIX/bin/php" -v | grep "PHP 5.2"; then
    "$pear" upgrade pear

    #"$pear" channel-discover components.ez.no
    "$pear" channel-discover pear.symfony-project.com
    "$pear" channel-discover pear.symfony.com
    "$pear" channel-discover pear.phpunit.de

    "$pear" install "phpunit/File_Iterator-1.3.2"
    "$pear" install "phpunit/Text_Template-1.1.2"
    "$pear" install "phpunit/PHP_Timer-1.0.3"
    "$pear" install "phpunit/PHPUnit-3.6.12"
fi
