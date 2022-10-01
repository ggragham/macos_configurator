#!/usr/bin/env bash

# Interactive menu to execute config scripts.

trap 'errMsg' ERR
cd "$(dirname "$0")" || exit "$?"

USERNAME="$SUDO_USER"
SCRIPT_PATH="../scripts"

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

    local select="*"
    while :; do
        clear
        echo "MacOS Configurator"
        echo
        echo "1. System config"
        echo "2. Base config"
        echo
        echo "0. Exit"
        echo

        case $select in
        1)
            bash "$SCRIPT_PATH/config_system.sh"
            select="*"
            ;;
        2)
            runAsUser bash "$SCRIPT_PATH/config_base.sh"
            select="*"
            ;;
        0)
            exit 0
            ;;
        *)
            read -rp "Select: " select
            continue
            ;;
        esac
    done
}

main
