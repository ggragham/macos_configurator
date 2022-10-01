#!/usr/bin/env bash

# Interactive menu to execute privacy scripts.

trap 'errMsg' ERR
cd "$(dirname "$0")" || exit "$?"

USERNAME="$SUDO_USER"
SCRIPT_PATH="../scripts"

errMsg() {
    echo "Failed"
    pressAnyKeyToContinue
    exit 1
}

isSudo() {
    if [[ $EUID != 0 ]]; then
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
        echo
        echo "1. Privacy config"
        echo "2. Privacy cleanup"
        echo "3. Disable services"
        echo
        echo "0. Back"
        echo

        case $select in
        1)
            runAsUser bash "$SCRIPT_PATH/privacy_as_user.sh"
            bash "$SCRIPT_PATH/privacy_as_sudo.sh"
            echo "Done"
            pressAnyKeyToContinue
            select="*"
            ;;
        2)
            runAsUser bash "$SCRIPT_PATH/clean_as_user.sh"
            bash "$SCRIPT_PATH/clean_as_sudo.sh"
            echo "Done"
            pressAnyKeyToContinue
            select="*"
            ;;
        3)
            bash "$SCRIPT_PATH/ext_macos_home_call.sh"
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
