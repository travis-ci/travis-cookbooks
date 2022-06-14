#!/usr/bin/env bash

set -o errexit

function main() {

  local JAVA_VERSION
  JAVA_VERSION="$1"
  sudo apt-get update -yqq
  if [[ "$JAVA_VERSION" == "8" ]]; then
    JAVA_VERSION="1.8.0"
  fi
  PACKAGE="java-${JAVA_VERSION}-amazon-corretto-jdk"
  if ! dpkg -s "$PACKAGE" >/dev/null 2>&1; then
    wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add -
    sudo add-apt-repository 'deb https://apt.corretto.aws stable main'
    sudo apt-get update -yqq
    sudo apt-get -yqq --no-install-suggests --no-install-recommends install "$PACKAGE" || true
    travis_cmd "export JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-amazon-corretto" --echo
    travis_cmd 'export PATH="$JAVA_HOME/bin:$PATH"' --echo
    sudo update-java-alternatives -s "$PACKAGE"*
  fi

}

main "$@"
