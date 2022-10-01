#!/usr/bin/env bash

# Initial script.
# Install xcode-tools.
# Clone repo and execute MacOS Configurator.

trap 'errMsg' ERR
cd "$(dirname "$0")" || exit "$?"

USERNAME="$SUDO_USER"
DEST_PATH="/Users/$USERNAME/.local/opt"
REPO_NAME="macos_configurator"
REPO_LINK="https://github.com/ggragham/macos_configurator.git"
SCRIPT_NAME="install.sh"
EXECUTE="$DEST_PATH/$REPO_NAME/$SCRIPT_NAME"

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

installXcodeTools() {
	# Check if git is installed by return code
	if git --version 2>/dev/null 1>&2; then
		return "$?"
	else
		if xcode-select --install; then
			echo "Press any key when the installation has completed"
			pressAnyKeyToContinue
		else
			local errcode="$?"
			echo "Failed to install xcode-tools"
			pressAnyKeyToContinue
			exit "$errcode"
		fi
	fi
}

cloneRepo() {
	runAsUser mkdir -p "$DEST_PATH"

	if runAsUser git clone "$REPO_LINK" "$DEST_PATH/$REPO_NAME"; then
		return "$?"
	else
		local errcode="$?"
		echo "Failed to clone repo"
		exit "$errcode"
	fi
}

runConfigurator() {
	if bash "$EXECUTE"; then
		return "$?"
	else
		local errcode="$?"
		echo "Failed to start MacOS Configurator"
		exit "$errcode"
	fi
}

main() {
	isSudo
	installXcodeTools
	cloneRepo
	runConfigurator
}

main
