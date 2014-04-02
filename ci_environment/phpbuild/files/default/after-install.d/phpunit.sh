#!/bin/bash

set -e

if [ -n "$PHP_BUILD_DEBUG" ]; then
    set -x
fi

pyrus="$PREFIX/bin/pyrus"
pear="$PREFIX/bin/pear"

use_pear() {
    "$pear" upgrade pear

    #"$pear" channel-discover components.ez.no
    "$pear" channel-discover pear.symfony-project.com
    "$pear" channel-discover pear.symfony.com
    "$pear" channel-discover pear.phpunit.de

    if "$PREFIX/bin/php" -v | grep "PHP 5.2"; then
        "$pear" install "phpunit/File_Iterator-1.3.2"
        "$pear" install "phpunit/Text_Template-1.1.2"
        "$pear" install "phpunit/PHP_Timer-1.0.3"
        "$pear" install "phpunit/PHPUnit-3.6.12"
    else
        "$pear" install "phpunit/PHPUnit"
    fi
}

use_pyrus() {
    # ezComponents' PEAR Channel somehow not works with Pyrus
    # so manually download and install the package files.
    _ezcomponents_hack() {
        local base_url="http://components.ez.no/get/$package"
        local ezcBase="$base_url/Base-1.8.tgz"
        local ezcConsoleTools="$base_url/ConsoleTools-1.6.1.tgz"

        "$pyrus" install "$ezcBase" "$ezcConsoleTools"
    }

    # Set up the required channels
    #"$pyrus" channel-discover "components.ez.no"
    "$pyrus" channel-discover "pear.symfony-project.com"
    "$pyrus" channel-discover "pear.phpunit.de"
    "$pyrus" channel-discover "pear.phpunit.de" > /dev/null

    #_ezcomponents_hack

    "$pyrus" install "phpunit/PHPUnit"
}

if [ -f "$pyrus" ]; then
    use_pyrus
else
    if [ -f "$pear" ]; then
        use_pear
    else
        echo "Neither pear nor pyrus found in $PREFIX/bin. Aborting" >&3
    fi
fi
