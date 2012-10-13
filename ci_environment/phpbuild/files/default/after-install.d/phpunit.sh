#!/bin/bash

set -e

pyrus="$PREFIX/bin/pyrus"
pear="$PREFIX/bin/pear"

use_pear() {
    "$pear" upgrade pear

    "$pear" channel-discover components.ez.no
    "$pear" channel-discover pear.symfony-project.com
    "$pear" channel-discover pear.phpunit.de

    if [[ "$PHP_VERSION" == "5.2.17" ]]
    then
        echo "Installing PHPUnit 3.6.x for PHP 5.2..."
        "$pear" install "phpunit/PHPUnit-3.6.12"
    else
        echo "Installing latest PHPUnit..."
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
    "$pyrus" channel-discover "components.ez.no"
    "$pyrus" channel-discover "pear.symfony-project.com"
    "$pyrus" channel-discover "pear.phpunit.de"

    _ezcomponents_hack

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
