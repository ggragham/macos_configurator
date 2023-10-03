#!/usr/bin/env bash

# Install core packages.

trap 'errMsg' ERR
cd "$(dirname "$0")" || exit "$?"

CONFIG_PATH="../config"
CONFIG_DEST="$HOME/.config"
PLIST_PATH="$CONFIG_PATH/plists"
PKG_LIST_PATH="../pkgs"
HOME_PATH="/Users/$USER"
OPT_PATH="$HOME_PATH/.local/opt"

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


applyLocalConfigs() {
    applyConfigs() { (
        set -eu
        cp -rf "$CONFIG_PATH/.config/." "$CONFIG_DEST"
        brew services start autoraise
        defaults import com.knollsoft.Rectangle "$PLIST_PATH/com.knollsoft.Rectangle.xml"
    ); }

    if applyConfigs; then
        echo "Configs applied"
    else
        local errcode="$?"
        echo "Failed to apply configs"
        pressAnyKeyToContinue
        exit "$errcode"
    fi
}

main() {
    doNotRunAsRoot

    applyLocalConfigs

    pressAnyKeyToContinue
}

main
