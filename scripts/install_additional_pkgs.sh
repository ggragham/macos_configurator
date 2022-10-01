#!/usr/bin/env bash

# Install additional packages.

trap 'errMsg' ERR
cd "$(dirname "$0")" || exit "$?"

PKG_LIST_PATH="../pkgs"
HOME_PATH="/Users/$USER"
LOCAL_PATH="$HOME_PATH/.local"
BIN_PATH="$LOCAL_PATH/bin"

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

downloadScritps() {
    local pkgsFile=""
    pkgsFile="$(cat "$PKG_LIST_PATH/scripts.pkgs")"
    IFS=$'\n'

    for scriptName in $pkgsFile; do
        echo "Downloading $scriptName"
        curl "https://raw.githubusercontent.com/ggragham/just_bunch_of_scripts/master/bin/$scriptName" -o "$BIN_PATH/$scriptName"
        chmod +x "$BIN_PATH/$scriptName"
    done

    echo "Scripts has been downloaded"
}
main() {
    doNotRunAsRoot

    installAdditionalPkgs
    downloadScritps

    pressAnyKeyToContinue
}

main
