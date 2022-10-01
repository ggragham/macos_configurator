#!/usr/bin/env bash

# Interactive menu to execute installation scripts.

trap 'errMsg' ERR
cd "$(dirname "$0")" || exit "$?"

SCRIPT_PATH="../scripts"

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

main() {
    isSudo

    local select="*"
    while :; do
        clear
        echo "MacOS Configurator"
        echo
        echo "1. Install core packages"
        echo "2. Install additional packages"
        echo "3. Install DevOps packages"
        echo
        echo "0. Exit"
        echo

        case $select in
        1)
            bash "$SCRIPT_PATH/install_core_pkgs.sh"
            select="*"
            ;;
        2)
            bash "$SCRIPT_PATH/install_additional_pkgs.sh"
            select="*"
            ;;
        3)
            bash "$SCRIPT_PATH/install_devops_pkgs.sh"
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
