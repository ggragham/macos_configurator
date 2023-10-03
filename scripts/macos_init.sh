#!/usr/bin/env bash
export HOMEBREW_NO_ANALYTICS=1

trap 'errMsg' ERR
cd "$(dirname "$0")" || exit "$?"

USERNAME="$SUDO_USER"
HOME_PATH="/Users/$SUDO_USER"
CONFIG_PATH="$HOME/.config"
LOCAL_PATH="$HOME_PATH/.local"
OPT_PATH="$LOCAL_PATH/opt"
BIN_PATH="$LOCAL_PATH/bin"
GAMES_PATH="$LOCAL_PATH/games"

errMsg() {
    echo "Failed"
    pressAnyKeyToContinue
    exit 1
}

isSudo() {
    if [[ $EUID != 0 ]] || [[ -z $USERNAME ]]; then
        echo "Run script with sudo"
        exit 1
    fi
}

runAsUser() {
    sudo -u "$USERNAME" "$@"
}

pressAnyKeyToContinue() {
    read -n 1 -s -r -p "Press any key to continue"
    echo
}

makeLocalDirs() {
    makeDirs() { (
        set -eu
        runAsUser mkdir -p "$CONFIG_PATH"
        runAsUser mkdir -p "$OPT_PATH"
        runAsUser mkdir -p "$BIN_PATH"
        runAsUser mkdir -p "$GAMES_PATH"
    ); }

    if makeDirs; then
        echo "Local dirs have been created"
    else
        local errcode="$?"
        echo "Failed to create local dirs"
        pressAnyKeyToContinue
        exit "$errcode"
    fi
}

main() {
    isSudo

    makeLocalDirs

    pressAnyKeyToContinue
}

main
