#!/usr/bin/env bash

# Install devops packages.

trap 'errMsg' ERR
cd "$(dirname "$0")" || exit "$?"

PKG_LIST_PATH="../pkgs"
CONFIG_PATH="../config"
HOME_PATH="/Users/$USER"
LOCAL_PATH="$HOME_PATH/.local"
OPT_PATH="$LOCAL_PATH/opt"

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

installAdditionalPkgs() {
    local brewfile="$PKG_LIST_PATH/devops.brewfile"
    if brew bundle --file="$brewfile"; then
        echo "Brew pkgs has been installed"
    else
        local errcode="$?"
        echo "Failed to install brew pkgs"
        pressAnyKeyToContinue
        exit "$errcode"
    fi
}

configVSCodium() {
    local codiumConfigDest="$HOME_PATH/Library/Application Support/VSCodium/User"
    mkdir -p "$codiumConfigDest"
    cp -f "$CONFIG_PATH/vsc_settings.json" "$codiumConfigDest/settings.json"

    file=$(cat $PKG_LIST_PATH/vscode_extensions.pkgs)
    IFS=$'\n'
    for extension in $file; do
        codium --install-extension "$extension"
    done
    echo "VSCodium has been installed"
}

installOpt() {
    local optName="$1"
    local optFileName="$2"
    local downloadURL="$3"
    curl "$downloadURL" -o "$OPT_PATH/$optFileName"

    if [[ -f "$OPT_PATH/$optFileName" ]]; then
        bash "$OPT_PATH/$optFileName"
        echo "$optName has been installed"
    else
        echo "Failed to install $optName"
        pressAnyKeyToContinue
        exit 1
    fi
}

installNVM() {
    local optName="Node Version Manager"
    local optFileName=install_nvm.sh
    local downloadURL="https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh"
    export NVM_DIR=$OPT_PATH/nvm
    mkdir -p "$NVM_DIR"
    installOpt "$optName" "$optFileName" "$downloadURL"
}

installPyenv() {
    local optName="Simple Python Version Management"
    local optFileName=install_pyenv.sh
    local downloadURL="https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer"
    export PYENV_ROOT=$OPT_PATH/pyenv
    installOpt "$optName" "$optFileName" "$downloadURL"
}

main() {
    doNotRunAsRoot

    installAdditionalPkgs
    configVSCodium
    installNVM
    installPyenv

    pressAnyKeyToContinue
}

main
