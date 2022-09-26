#!/usr/bin/env bash
export HOMEBREW_NO_ANALYTICS=1

# Initial script.
# Install xcode-tools, brew and ansible.
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
	zecho "Failed"
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

installBrew() {
	runAsUser bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	local errcode="$?"
	if [[ $errcode ]]; then
		echo 'Disable Homebrew user behavior analytics'
		command='export HOMEBREW_NO_ANALYTICS=1'
		declare -a profile_files=("$HOME/.bash_profile" "$HOME/.zprofile")
		for profile_file in "${profile_files[@]}"; do
			touch "$profile_file"
			if ! grep -q "$command" "${profile_file}"; then
				echo "$command" >>"$profile_file"
				echo "[$profile_file] Configured"
			else
				echo "[$profile_file] No need for any action, already configured"
			fi
		done
		echo "Brew has been installed"
	else
		echo "Failed to install brew"
		pressAnyKeyToContinue
		exit "$errcode"
	fi
}

installAnsible() {
	runAsUser brew install ansible
	local errcode="$?"
	if [[ $errcode ]]; then
		echo "Ansible has been installed"
	else
		local errcode="$?"
		echo "Failed to isntall Ansible"
		pressAnyKeyToContinue
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
	installBrew
	installAnsible
	# cloneRepo
	# runConfigurator
}

main
