#!/usr/bin/env bash

##################
# OpenInTerminal #
##################

# TODO: Make decoded xml file
DEFAULT_TERMINAL_SHORTCUT="<62706C6973743030D4010203040506070A582476657273696F6E592461726368697665725424746F7058246F626A6563747312000186A05F100F4E534B657965644172636869766572D1080954726F6F748001A30B0C1355246E756C6CD30D0E0F101112574B6579436F64655624636C6173735D4D6F646966696572466C616773102480021200100000D2141516175A24636C6173736E616D655824636C61737365735B4D415353686F7274637574A218195B4D415353686F7274637574584E534F626A65637408111A24293237494C5153575D646C738183858A8F9AA3AFB2BE0000000000000101000000000000001A000000000000000000000000000000C7>"
CUSTOM_MENU_OPTIONS="<5B7B226E616D65223A226B69747479222C2274797065223A227465726D696E616C222C2262756E646C654964223A226E65742E6B6F766964676F79616C2E6B69747479227D2C7B226E616D65223A225653436F6469756D222C2274797065223A22656469746F72222C2262756E646C654964223A22636F6D2E76697375616C73747564696F2E636F64652E6F7373227D2C7B226E616D65223A225465787445646974222C2274797065223A22656469746F72222C2262756E646C654964223A22636F6D2E6170706C652E5465787445646974227D5D>"

# General
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal LaunchAtLogin 1
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal QuickToggle 1
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal HideStatusItem 1
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal HideContextMenuItems 0
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal DefaultTerminal kitty
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal DefaultEditor TextEdit

# Custom
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal CustomMenuOptions "$CUSTOM_MENU_OPTIONS"
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal CustomMenuApplyToToolbar 1
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal CustomMenuApplyToContext 1
defaults write "$HOME"/Library/Group\ Containers/group.wang.jianing.app.OpenInTerminal/Library/Preferences/group.wang.jianing.app.OpenInTerminal CustomMenuIconOption simple

# Advanced
defaults write wang.jianing.app.OpenInTerminal OIT_DefaultTerminalShortcut "$DEFAULT_TERMINAL_SHORTCUT"
