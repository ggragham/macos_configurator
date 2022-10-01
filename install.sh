#!/usr/bin/env bash

# Main script.
# Interactive menu to execute other
# installation and configuration scripts.

trap 'errMsg' ERR
cd "$(dirname "$0")" || exit "$?"

USERNAME="$SUDO_USER"
SCRIPT_PATH="./scripts"

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

main() {
	isSudo

	local select="*"
	while :; do
		clear
		echo "MacOS Configurator"
		echo
		echo "1. Privacy settings"
		echo "2. Initial configuration"
		echo "3. Config system"
		echo "4. Install pkgs"
		echo
		echo "0. Exit"
		echo

		case $select in
		1)
			bash "$SCRIPT_PATH/select_privacy_config.sh"
			select="*"
			;;
		2)
			bash "$SCRIPT_PATH/macos_init.sh"
			select="*"
			;;
		3)
			runAsUser bash "$SCRIPT_PATH/config.sh"
			select="*"
			;;
		4)
			runAsUser bash "$SCRIPT_PATH/select_pkgs.sh"
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
