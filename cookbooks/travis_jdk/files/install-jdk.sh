#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

function usage() {
cat << EOF
Usage: $0 -f <feature> [-t <target-dir>]

Options:
  -f|--feature     JDK version to install (8, 9, 10, 11, 12, 17, 21, 24)
  -t|--target      Optional target directory (default: auto-detected from archive)
EOF
exit 0
}

function parse_options() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -f|--feature)
                feature="$2"
                shift 2
                ;;
            -t|--target)
                target="$2"
                shift 2
                ;;
            *)
                echo "Unknown option: $1"
                usage
                ;;
        esac
    done

    if [[ -z "${feature:-}" ]]; then
        echo "Error: --feature is required."
    fi
}

function get_jdk_url() {
    case "$feature" in
        8)  url="https://download.bell-sw.com/java/8u462+11/bellsoft-jdk8u462+11-linux-amd64.tar.gz" ;;
        9)  url="https://download.java.net/java/GA/jdk9/9.0.4/binaries/openjdk-9.0.4_linux-x64_bin.tar.gz" ;;
        10) url="https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz" ;;
        11) url="https://download.bell-sw.com/java/11.0.28+12/bellsoft-jdk11.0.28+12-linux-amd64.tar.gz" ;;
        12) url="https://download.java.net/java/GA/jdk12.0.2/e482c34c86bd4bf8b56c0b35558996b9/10/GPL/openjdk-12.0.2_linux-x64_bin.tar.gz" ;;
        17) url="https://download.bell-sw.com/java/17.0.16+12/bellsoft-jdk17.0.16+12-linux-amd64.tar.gz" ;;
        21) url="https://download.bell-sw.com/java/21.0.8+12/bellsoft-jdk21.0.8+12-linux-amd64.tar.gz" ;;
        24) url="https://download.bell-sw.com/java/24.0.2+12/bellsoft-jdk24.0.2+12-linux-amd64.tar.gz" ;;
        *)
            echo "Unsupported JDK feature: $feature"
            exit 1
            ;;
    esac
}

function install_jdk() {
    temp_dir=$(mktemp -d)
    trap "rm -rf \"$temp_dir\"" EXIT

    cd "$temp_dir"
    echo "Downloading JDK $feature..."
    curl -fsSL -o jdk.tar.gz "$url"

    echo "Extracting..."
    tar -xf jdk.tar.gz

    if [[ -z "${target:-}" ]]; then
        target=$(find . -maxdepth 1 -type d -name "jdk*" | head -n 1)
        target=$(realpath "$target")
    else
        mkdir -p "$target"
        tar --strip-components=1 -xf jdk.tar.gz -C "$target"
        target=$(realpath "$target")
    fi

    export JAVA_HOME="$target"
    export PATH="$JAVA_HOME/bin:$PATH"

    echo "JDK $feature installed to: $JAVA_HOME"
    java -version
}


parse_options "$@"
get_jdk_url
install_jdk
