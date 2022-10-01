#!/usr/bin/env bash

# Download and execute macOS-home-call-drop.

trap 'errMsg' ERR
cd "$(dirname "$0")" || exit "$?"

USERNAME="$SUDO_USER"
EXT_PATH="../ext"
REPO_PATH="$EXT_PATH/macOS-home-call-drop"
REPO_LINK="https://github.com/karek314/macOS-home-call-drop.git"

errMsg() {
    echo "Failed"
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

main() {
    isSudo
    runAsUser git clone "$REPO_LINK" "$REPO_PATH"
    cd "$REPO_PATH" || exit "$?"
    bash homecall.sh audit

    local select="*"
    while :; do
        case $select in
        y)
            runAsUser bash homecall.sh fix
            bash homecall.sh fix
            pressAnyKeyToContinue
            exit 0
            ;;
        n)
            exit 0
            ;;
        *)
            read -rp "Apply? (y/n) " select
            continue
            ;;
        esac
    done
}

main
