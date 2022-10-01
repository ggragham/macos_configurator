#!/usr/bin/env bash

# Install core packages.

trap 'errMsg' ERR
cd "$(dirname "$0")" || exit "$?"

CONFIG_PATH="../config"
CONFIG_DEST="$HOME/.config"
PLIST_PATH="$CONFIG_PATH/plists"
PKG_LIST_PATH="../pkgs"
HOME_PATH="/Users/$USER"
OPT_PATH="$HOME_PATH/.local/opt"

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

installOMZ() {
    local omzDownloadURL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
    curl "$omzDownloadURL" -o "$OPT_PATH/install.sh"
    export ZSH=$OPT_PATH/oh-my-zsh
    export CHSH=no
    export RUNZSH=no
    if [[ -f "$OPT_PATH/install.sh" ]]; then
        bash "$OPT_PATH/install.sh"
        echo "Oh My Zsh has been installed"
    else
        local errcode="$?"
        echo "Failed to install Oh My Zsh"
        pressAnyKeyToContinue
        exit "$errcode"
    fi

}

installOMZPlugins() {
    local pluginDir="$ZSH/custom/plugins"
    if [[ -d $pluginDir ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$pluginDir/zsh-syntax-highlighting"
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$pluginDir/zsh-autosuggestions"
        echo "Plugins for Oh My Zsh have been installed"
    else
        echo "Failed to install plugins for Oh My Zsh"
        pressAnyKeyToContinue
        exit 1
    fi
}

applyOMZConfig() {
    local omzConfig="$CONFIG_PATH/omz"
    if cp -rf "$omzConfig/." "$HOME"; then
        echo "OMZ config has been loaded"
    else
        local errcode="$?"
        echo "Failed to load OMZ config"
        pressAnyKeyToContinue
        exit "$errcode"
    fi
}

installCorePkgs() {
    local brewfile="$PKG_LIST_PATH/core.brewfile"
    if brew bundle --file="$brewfile"; then
        echo "Brew pkgs has been installed"
    else
        local errcode="$?"
        echo "Failed to install brew pkgs"
        pressAnyKeyToContinue
        exit "$errcode"
    fi
}

applyLocalConfigs() {
    applyConfigs() { (
        set -eu
        cp -rf "$CONFIG_PATH/.config/." "$CONFIG_DEST"
        brew services start autoraise
        defaults import com.knollsoft.Rectangle "$PLIST_PATH/com.knollsoft.Rectangle.xml"
    ); }

    if applyConfigs; then
        echo "Configs applied"
    else
        local errcode="$?"
        echo "Failed to apply configs"
        pressAnyKeyToContinue
        exit "$errcode"
    fi
}

main() {
    doNotRunAsRoot

    installOMZ
    installOMZPlugins
    applyOMZConfig
    installCorePkgs
    applyLocalConfigs

    pressAnyKeyToContinue
}

main
