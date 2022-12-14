#!/usr/bin/env bash
export HOMEBREW_NO_ANALYTICS=1

trap 'errMsg' ERR
cd "$(dirname "$0")" || exit "$?"

USERNAME="$SUDO_USER"
HOME_PATH="/Users/$SUDO_USER"
CONFIG_PATH="$HOME/.config"
LOCAL_PATH="$HOME_PATH/.local"
OPT_PATH="$LOCAL_PATH/opt"
BIN_PATH="$LOCAL_PATH/bin"
GAMES_PATH="$LOCAL_PATH/games"

errMsg() {
    echo "Failed"
    pressAnyKeyToContinue
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

makeLocalDirs() {
    makeDirs() { (
        set -eu
        runAsUser mkdir -p "$CONFIG_PATH"
        runAsUser mkdir -p "$OPT_PATH"
        runAsUser mkdir -p "$BIN_PATH"
        runAsUser mkdir -p "$GAMES_PATH"
    ); }

    if makeDirs; then
        echo "Local dirs have been created"
    else
        local errcode="$?"
        echo "Failed to create local dirs"
        pressAnyKeyToContinue
        exit "$errcode"
    fi
}

main() {
    isSudo

    installBrew
    makeLocalDirs

    pressAnyKeyToContinue
}

main
