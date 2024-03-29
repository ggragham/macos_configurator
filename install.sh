#!/usr/bin/env bash

# Main script.
# Check and download dependencies
# Interactive menu to execute playbooks.

# Global constants
readonly CURRENT_PLATFORM="$(uname -s)"
readonly REPO_NAME="macos_configurator"
readonly REPO_LINK="https://github.com/ggragham/${REPO_NAME}.git"
readonly DEFAULT_REPO_PATH="$HOME/.local/opt/$REPO_NAME"

# Global vars
TEMP_DIR="$(mktemp -d)"
USER_PASSWORD="${USER_PASSWORD:-}"
REPO_ROOT_PATH="${REPO_ROOT_PATH:-$HOME/.local/opt/$REPO_NAME}"
SCRIPT_PATH="$(dirname "$0")"
if [[ -d "$SCRIPT_PATH/.git" ]]; then
	REPO_ROOT_PATH="$SCRIPT_PATH"
else
	REPO_ROOT_PATH="${REPO_ROOT_PATH:-"$DEFAULT_REPO_PATH"}"
fi
ANSIBLE_PLAYBOOK_PATH="$REPO_ROOT_PATH/ansible"

# Text formating
readonly NORMAL='\033[0m'
readonly BOLD='\033[1m'
readonly LONG_TAB='\033[40G'
readonly LIGHTBLUE='\033[1;34m'
# readonly BLINK='\033[5m'
# readonly RED='\033[0;31m'
# readonly GREEN='\033[0;32m'

cleanup() {
	local exitStatus="$?"
	unset USER_PASSWORD
	rm -rf "$TEMP_DIR"
	exit "$exitStatus"
}

trap cleanup TERM EXIT

checkSudo() {
	if [ "$EUID" -eq 0 ]; then
		echo "Error: Running this script with sudo is not allowed."
		exit 1
	fi
}

installInitDeps() {
	if [[ "$CURRENT_PLATFORM" != "Darwin" ]]; then
		echo -e "Platform ${BOLD}$CURRENT_PLATFORM${NORMAL} is not supported"
		exit 1
	fi

	if ! brew --version 2>/dev/null 1>&2; then
		local brewInstallPath="$TEMP_DIR/brew_install.sh"

		(
			set -e
			echo "Installing Homebrew..."
			curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$brewInstallPath"
			/bin/bash "$brewInstallPath"
		) || {
			echo "Failed to install Homebrew. Exiting..."
			exit 2
		}
		echo "Brew installation complete"
	fi

	if ! ansible --version 2>/dev/null 1>&2; then
		(
			set -e
			echo "Installing Ansible..."
			brew update
			brew install ansible
		) || {
			echo "Failed to install Ansible. Exiting..."
			exit 2
		}
		echo "Ansible installation complete"
	fi
}

cloneRepo() {
	(
		set -eu
		mkdir -p "$REPO_ROOT_PATH"
		git clone "$REPO_LINK" "$REPO_ROOT_PATH"
	)
}

init() {
	installInitDeps
	if [ "$PWD/$0" != "$REPO_ROOT_PATH/$0" ]; then
		cloneRepo
	fi
	cd "$REPO_ROOT_PATH" || exit "$?"
}

enterUserPassword() {
	sudo -K

	checkPassword() {
		if echo "$USER_PASSWORD" | sudo -S true >/dev/null 2>&1; then
			sudo -K
			return 0
		else
			echo -e "\nSorry, try again."
			return 1
		fi
	}

	if [ -n "$USER_PASSWORD" ]; then
		if checkPassword; then
			return 0
		fi
		exit $?
	fi

	while :; do
		read -rsp "Password: " USER_PASSWORD
		if checkPassword; then
			break
		fi
	done

	return 0
}

pressAnyKeyToContinue() {
	read -n 1 -s -r -p "Press any key to continue"
	echo
}

asciiLogo() {
	cat <<'EOF'

___  ___           _____ _____   _____              __ _       
|  \/  |          |  _  /  ___| /  __ \            / _(_)      
| .  . | __ _  ___| | | \ `--.  | /  \/ ___  _ __ | |_ _  __ _ 
| |\/| |/ _` |/ __| | | |`--. \ | |    / _ \| '_ \|  _| |/ _` |
| |  | | (_| | (__\ \_/ /\__/ / | \__/\ (_) | | | | | | | (_| |
\_|  |_/\__,_|\___|\___/\____/   \____/\___/|_| |_|_| |_|\__, |
                                                          __/ |
                                                         |___/ 
EOF
}

printHeader() {
	clear
	echo -e "${LIGHTBLUE}${BOLD}"
	asciiLogo
	echo -e "${NORMAL}"
	echo -e "${LONG_TAB} By ${BOLD}ggragham${NORMAL}"
	echo
	echo -e "${LIGHTBLUE}Choose an option:${NORMAL}"
	echo
}

menuItem() {
	local number="$1"
	local text="$2"
	echo -e "${LIGHTBLUE}$number.${NORMAL} $text"
}

runAnsiblePlaybook() {
	local playbookName="$1"
	shift
	local tagsList="$*"
	ansible-playbook "$ANSIBLE_PLAYBOOK_PATH/$playbookName.yml" --tags "prepare,$tagsList" --extra-vars "ansible_become_password=$USER_PASSWORD"
}

# PKGs
installPackages() {
	local select="*"
	while :; do
		printHeader
		menuItem "1" "Install Base pkgs"
		menuItem "2" "Install Dev pkgs"
		echo
		menuItem "0" "Back"
		echo

		case $select in
		1)
			installBasePackages
			select="*"
			;;
		2)
			installDevPackages
			select="*"
			;;
		0)
			return 0
			;;
		*)
			read -rp "> " select
			continue
			;;
		esac
	done
}

installBasePackages() {
	local select="*"
	while :; do
		printHeader
		menuItem "1" "Install Homebrew PKGs"
		menuItem "2" "Install Oh My ZSH"
		menuItem "3" "Install Scripts"
		menuItem "4" "Install lporg"
		echo
		menuItem "0" "Back"
		echo

		case $select in
		1)
			runAnsiblePlaybook "install_pkgs" "brew"
			pressAnyKeyToContinue
			select="*"
			;;
		2)
			runAnsiblePlaybook "install_pkgs" "omz"
			pressAnyKeyToContinue
			select="*"
			;;
		3)
			runAnsiblePlaybook "install_pkgs" "script"
			pressAnyKeyToContinue
			select="*"
			;;
		4)
			runAnsiblePlaybook "install_pkgs" "lporg"
			pressAnyKeyToContinue
			select="*"
			;;
		0)
			return 0
			;;
		*)
			read -rp "> " select
			continue
			;;
		esac
	done
}

installDevPackages() {
	local select="*"
	while :; do
		printHeader
		menuItem "1" "Install Base DevOps PKGs"
		menuItem "2" "Install VSCodium"
		menuItem "3" "Install Virtualization PKGs"
		menuItem "4" "Install Docker"
		menuItem "5" "Install Kubernetes PKGs"
		menuItem "6" "Install PyEnv"
		menuItem "7" "Install Node Version Manager"
		echo
		menuItem "0" "Back"
		echo

		case $select in
		1)
			runAnsiblePlaybook "install_dev_pkgs" "devops"
			pressAnyKeyToContinue
			select="*"
			;;
		2)
			runAnsiblePlaybook "install_dev_pkgs" "vscodium"
			pressAnyKeyToContinue
			select="*"
			;;
		3)
			runAnsiblePlaybook "install_dev_pkgs" "virtualization"
			pressAnyKeyToContinue
			select="*"
			;;
		4)
			runAnsiblePlaybook "install_dev_pkgs" "docker"
			pressAnyKeyToContinue
			select="*"
			;;
		5)
			runAnsiblePlaybook "install_dev_pkgs" "kubernetes"
			pressAnyKeyToContinue
			select="*"
			;;
		6)
			runAnsiblePlaybook "install_dev_pkgs" "pyenv"
			pressAnyKeyToContinue
			select="*"
			;;
		7)
			runAnsiblePlaybook "install_dev_pkgs" "nvm"
			pressAnyKeyToContinue
			select="*"
			;;
		0)
			return 0
			;;
		*)
			read -rp "> " select
			continue
			;;
		esac
	done
}

# Config
applyConfig() {
	local select="*"
	while :; do
		printHeader
		menuItem "1" "Apply Settings"
		menuItem "2" "Apply Configs"
		menuItem "3" "Configure Apps"
		menuItem "4" "Organize Launchpad"
		echo
		menuItem "0" "Back"
		echo

		case $select in
		1)
			runAnsiblePlaybook "apply_config" "config_script"
			pressAnyKeyToContinue
			select="*"
			;;
		2)
			runAnsiblePlaybook "apply_config" "local_config_files"
			pressAnyKeyToContinue
			select="*"
			;;
		3)
			runAnsiblePlaybook "apply_config" "app_config"
			pressAnyKeyToContinue
			select="*"
			;;
		4)
			runAnsiblePlaybook "apply_config" "lporg"
			pressAnyKeyToContinue
			select="*"
			;;
		0)
			return 0
			;;
		*)
			read -rp "> " select
			continue
			;;
		esac
	done
}

# Privacy & Security
privacyAndSecurity() {
	local select="*"
	while :; do
		printHeader
		menuItem "1" "Apply Hosts"
		menuItem "2" "Apply Security Settings"
		menuItem "3" "Apply Privacy Settings"
		menuItem "4" "Cleanup"
		echo
		menuItem "0" "Back"
		echo

		case $select in
		1)
			runAnsiblePlaybook "privacy_and_security" "hosts"
			pressAnyKeyToContinue
			select="*"
			;;
		2)
			runAnsiblePlaybook "privacy_and_security" "security"
			pressAnyKeyToContinue
			select="*"
			;;
		3)
			runAnsiblePlaybook "privacy_and_security" "privacy"
			pressAnyKeyToContinue
			select="*"
			;;
		4)
			runAnsiblePlaybook "privacy_and_security" "cleanup"
			pressAnyKeyToContinue
			select="*"
			;;
		0)
			return 0
			;;
		*)
			read -rp "> " select
			continue
			;;
		esac
	done
}

main() {
	checkSudo
	enterUserPassword
	init

	local select="*"
	while :; do
		printHeader
		menuItem "1" "Install PKGs"
		menuItem "2" "Apply configs"
		menuItem "3" "Privacy & Security"
		echo
		menuItem "0" "Exit"
		echo

		case $select in
		1)
			installPackages
			select="*"
			;;
		2)
			applyConfig
			select="*"
			;;
		3)
			privacyAndSecurity
			select="*"
			;;
		0)
			return 0
			;;
		*)
			read -rp "> " select
			continue
			;;
		esac
	done
}

main
