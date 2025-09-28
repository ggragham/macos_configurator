#!/usr/bin/env bash

##################
# OpenInTerminal #
##################

# TODO: Make decoded xml file
CUSTOM_MENU_OPTIONS="<5B7B226E616D65223A22695465726D222C2274797065223A227465726D696E616C222C2262756E646C654964223A22636F6D2E676F6F676C65636F64652E697465726D32227D2C7B226E616D65223A225653436F6469756D222C2274797065223A22656469746F72222C2262756E646C654964223A22636F6D2E76697375616C73747564696F2E636F64652E6F7373227D2C7B226E616D65223A225465787445646974222C2274797065223A22656469746F72222C2262756E646C654964223A22636F6D2E6170706C652E5465787445646974227D5D>"

# General
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal LaunchAtLogin 1
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal QuickToggle 1
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal HideStatusItem 1
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal HideContextMenuItems 0
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal DefaultTerminal iTerm
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal DefaultEditor TextEdit

# Custom
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal CustomMenuOptions "$CUSTOM_MENU_OPTIONS"
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal CustomMenuApplyToToolbar 1
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal CustomMenuApplyToContext 1
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal CustomMenuIconOption simple

