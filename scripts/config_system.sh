#!/usr/bin/env bash

# System config.

trap 'errMsg' ERR
cd "$(dirname "$0")" || exit "$?"

USERNAME="$SUDO_USER"
SYSTEM_CONFIG_PATH="../system_conf"

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

pressAnyKeyToContinue() {
    read -n 1 -s -r -p "Press any key to continue"
    echo
}

loadHostsFile() {
    local hostsFileSource="$SYSTEM_CONFIG_PATH/hosts"
    local hostsFileDest="/etc/hosts"
    hostsFile="$(cat $hostsFileSource)"
    IFS=$'\n'
    # Find lines from $hostsFileSource in $hostsFileDest
    # and replace their values.
    # If there are no lines in file
    # it will add them.
    for line in $hostsFile; do
        selectedLine=$(echo -e "$line" | awk -F '=' '{print $1}')
        if grep -q "$selectedLine" "$hostsFileDest"; then
            sed -i "s/${selectedLine}.*/${line}/g" "$hostsFileDest" 2>/dev/null
        else
            echo -e "$line" >>"$hostsFileDest"
        fi
    done

    echo "Hosts file has been loaded"
}

main() {
    isSudo
    loadHostsFile
    pressAnyKeyToContinue
}

main
