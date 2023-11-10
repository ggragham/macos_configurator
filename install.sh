#!/usr/bin/env bash

# Main script.
# Check and download dependencies
# Interactive menu to execute playbooks.

cd "$(dirname "$0")" || exit "$?"

# Global vars
USERNAME="$SUDO_USER"
PRESERVE_USER_ENV="TMPDIR"
PRESERVE_ENV="${PRESERVE_USER_ENV},ANSIBLE_LOCALHOST_WARNING,ANSIBLE_INVENTORY_UNPARSED_WARNING"
CURRENT_PLATFORM="$(uname -s)"
DEST_PATH="/Users/$USERNAME/.local/opt"
REPO_NAME="macos_configurator"
REPO_LINK="https://github.com/ggragham/${REPO_NAME}.git"
SCRIPT_NAME="install.sh"
CURRENT_SCRIPT_PATH="$(readlink -f "$0")"
DEFAULT_SCRIPT_PATH="$DEST_PATH/$REPO_NAME/$SCRIPT_NAME"
REPO_ROOT_PATH="$(git rev-parse --show-toplevel 2>/dev/null)"
ANSIBLE_PLAYBOOK_PATH="$REPO_ROOT_PATH/ansible"

# Text formating
BOLD='\033[1m'
BLINK='\033[5m'
LONG_TAB='\033[40G'
RED='\033[0;31m'
LIGHTBLUE='\033[1;34m'
# GREEN='\033[0;32m'
NORMAL='\033[0m'

isSudo() {
	if [[ $EUID != 0 ]] || [[ -z $USERNAME ]]; then
		sudo --preserve-env="$PRESERVE_USER_ENV" bash "$SCRIPT_NAME"
		exit 1
	fi
}

runAsUser() {
	sudo --preserve-env="$PRESERVE_ENV" --user="$USERNAME" "$@"
}

pressAnyKeyToContinue() {
	read -n 1 -s -r -p "Press any key to continue"
	echo
}

installInitDeps() {
	createTmpDir() {
		tmpDir="$(runAsUser mktemp -d)"
	}

	deleteTmpDir() {
		if [ -n "$tmpDir" ] && [ -d "$tmpDir" ]; then
			rm -rf "$tmpDir"
		fi
	}

	trap deleteTmpDir EXIT INT

	if [[ "$CURRENT_PLATFORM" != "Darwin" ]]; then
		echo -e "Platform ${BOLD}$CURRENT_PLATFORM${NORMAL} is not supported"
		exit 1
	fi

	if ! brew --version 2>/dev/null 1>&2; then
		createTmpDir
		local brewInstallPath="$tmpDir/brew_install.sh"

		(
			set -e
			echo "Installing Homebrew..."
			runAsUser curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$brewInstallPath"
			runAsUser NONINTERACTIVE=1 /bin/bash "$brewInstallPath"
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
			runAsUser brew update
			runAsUser brew install ansible
		) || {
			echo "Failed to install Ansible. Exiting..."
			exit 2
		}
		echo "Ansible installation complete"
	fi
}

cloneRepo() {
	cloneMacOSConfigRepo() { (
		set -eu
		runAsUser mkdir -p "$DEST_PATH"
		runAsUser git clone "$REPO_LINK" "$DEST_PATH/$REPO_NAME"
	); }

	runConfigurator() {
		if bash "$DEFAULT_SCRIPT_PATH"; then
			exit "$?"
		else
			local errcode="$?"
			echo "Failed to start MacOS Configurator"
			exit "$errcode"
		fi
	}

	if [[ -d "./.git" ]]; then
		return 0
	elif [[ "$DEFAULT_SCRIPT_PATH" != "$CURRENT_SCRIPT_PATH" ]]; then
		if [[ ! -d "$DEST_PATH/$REPO_NAME" ]]; then
			cloneMacOSConfigRepo
		fi
		runConfigurator
	fi
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
	baseAnsiblePlaybook() {
		runAsUser ansible-playbook "$ANSIBLE_PLAYBOOK_PATH/install_pkgs.yml" --tags "prepare,$*"
	}

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
			baseAnsiblePlaybook "brew"
			pressAnyKeyToContinue
			select="*"
			;;
		2)
			baseAnsiblePlaybook "omz"
			pressAnyKeyToContinue
			select="*"
			;;
		3)
			baseAnsiblePlaybook "script"
			pressAnyKeyToContinue
			select="*"
			;;
		4)
			baseAnsiblePlaybook "lporg"
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
	devAnsiblePlaybook() {
		runAsUser ansible-playbook "$ANSIBLE_PLAYBOOK_PATH/install_dev_pkgs.yml" --tags "prepare,$*"
	}

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
			devAnsiblePlaybook "devops"
			pressAnyKeyToContinue
			select="*"
			;;
		2)
			devAnsiblePlaybook "vscodium"
			pressAnyKeyToContinue
			select="*"
			;;
		3)
			devAnsiblePlaybook "virtualization"
			pressAnyKeyToContinue
			select="*"
			;;
		4)
			devAnsiblePlaybook "docker"
			pressAnyKeyToContinue
			select="*"
			;;
		5)
			devAnsiblePlaybook "kubernetes"
			pressAnyKeyToContinue
			select="*"
			;;
		6)
			devAnsiblePlaybook "pyenv"
			pressAnyKeyToContinue
			select="*"
			;;
		7)
			devAnsiblePlaybook "nvm"
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
	configAnsiblePlaybook() {
		runAsUser ansible-playbook "$ANSIBLE_PLAYBOOK_PATH/apply_config.yml" --tags "prepare,$*"
	}

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
			configAnsiblePlaybook "config_script"
			pressAnyKeyToContinue
			select="*"
			;;
		2)
			configAnsiblePlaybook "local_config_files"
			pressAnyKeyToContinue
			select="*"
			;;
		3)
			configAnsiblePlaybook "app_config"
			pressAnyKeyToContinue
			select="*"
			;;
		4)
			configAnsiblePlaybook "lporg"
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
	privacyAndSecurityAnsiblePlaybook() {
		ansible-playbook "$ANSIBLE_PLAYBOOK_PATH/privacy_and_security.yml" --tags "$*"
	}

	clear
	echo -e "\n\n\t${RED}${BLINK}Some of these tasks may require disabling SIP (System Integrity Protection)${NORMAL}\n\n"
	pressAnyKeyToContinue

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
			privacyAndSecurityAnsiblePlaybook "hosts"
			pressAnyKeyToContinue
			select="*"
			;;
		2)
			privacyAndSecurityAnsiblePlaybook "security"
			pressAnyKeyToContinue
			select="*"
			;;
		3)
			privacyAndSecurityAnsiblePlaybook "privacy"
			pressAnyKeyToContinue
			select="*"
			;;
		4)
			privacyAndSecurityAnsiblePlaybook "cleanup"
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
	isSudo
	installInitDeps
	cloneRepo

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
			exit 0
			;;
		*)
			read -rp "> " select
			continue
			;;
		esac
	done
}

main
