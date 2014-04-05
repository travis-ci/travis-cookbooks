#!/usr/bin/env bash

set -e

PHP_VERSION=$(phpenv version-name)

switch_hhvm() {
  HHVM_PACKAGE=$1

  if ! dpkg -s $HHVM_PACKAGE 2> /dev/null | grep Status | grep installed > /dev/null; then
    echo "Installing last $HHVM_PACKAGE!"
    sudo apt-get update > /dev/null
    set +e
    sudo apt-get install $HHVM_PACKAGE > /dev/null

    if [[ $? != 0 ]]; then
      echo "There was an error installing $HHVM_PACKAGE..."
    else
      echo "Successfully installed $HHVM_PACKAGE!"
    fi
    set -e
  fi
}

if [[ $PHP_VERSION == "hhvm-nightly" ]]; then
  switch_hhvm hhvm-nightly
elif [[ $PHP_VERSION =~ "hhvm" && ! $PHP_VERSION =~ "nightly" ]]; then
  switch_hhvm hhvm
fi
