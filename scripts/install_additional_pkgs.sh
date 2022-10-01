#!/usr/bin/env bash

# Install additional packages.

trap 'errMsg' ERR
cd "$(dirname "$0")" || exit "$?"

PKG_LIST_PATH="../pkgs"

errMsg() {
    echo "Failed"
    exit 1
}

doNotRunAsRoot() {
    if [[ $EUID == 0 ]]; then
        echo "Don't run this script as root"
        exit 1
    fi
}

pressAnyKeyToContinue() {
    read -n 1 -s -r -p "Press any key to continue"
    echo
}

installAdditionalPkgs() {
    local brewfile="$PKG_LIST_PATH/other.brewfile"
    if brew bundle --file="$brewfile"; then
        echo "Brew pkgs has been installed"
    else
        local errcode="$?"
        echo "Failed to install brew pkgs"
        pressAnyKeyToContinue
        exit "$errcode"
    fi
}

main() {
    doNotRunAsRoot
    installAdditionalPkgs
    pressAnyKeyToContinue
}

main
