#!/usr/bin/env bash

# ----------------------------------------------------------
# --------------------- System Settings --------------------
# ----------------------------------------------------------

###############
### Network ###
###############
# Other Services > Thunderbolt Bridge [disable]
networksetup -setnetworkserviceenabled 'Thunderbolt Bridge' Off

###############
### General ###
###############
# AirDrop & Handoff > Allow Handoff between this Mac and your iCloud devices [disable]
defaults write "$HOME/Library/Preferences/ByHost/com.apple.coreservices.useractivityd.plist" ActivityAdvertisingAllowed -bool false
defaults write "$HOME/Library/Preferences/ByHost/com.apple.coreservices.useractivityd.plist" ActivityReceivingAllowed -bool false
# Language & Region > Preferred Languages
defaults write NSGlobalDomain AppleLanguages -array "en-UA" "uk-UA" "ru-UA"
# Date & Time > 24-hour time [disable]
defaults write NSGlobalDomain AppleICUForce12HourTime 1

#####################
### Accessibility ###
#####################
# Display > Reduce transperecy [enable]
# defaults write com.apple.universalaccess reduceTransparency -bool true

######################
### Control Centre ###
######################
# Control Centre Modules > Bluetooth [Show in Menu Bar]
defaults -currentHost write com.apple.controlcenter Bluetooth -int 18
# Control Centre Modules > Sound [Always Show in Menu Bar]
defaults -currentHost write com.apple.controlcenter Sound -int 18
# Other Modules > Accessibility Shortcuts [Show in Control Centre]
defaults -currentHost write com.apple.controlcenter AccessibilityShortcuts -int 1
# Other Modules > Battery [Show in Menu Bar & Control Centre]
defaults -currentHost write com.apple.controlcenter Battery -int 19
# Other Modules > Battery [Show Percentage]
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true
# Other Modules > Hearing [Show in Menu Bar & Control Centre]
defaults -currentHost write com.apple.controlcenter Hearing -int 19
# Other Modules > Fast User Switching [Show in Control Centre]
defaults -currentHost write com.apple.controlcenter UserSwitcher -int 9
# Other Modules > Keyboard Brightness [Show in Control Centre]
defaults -currentHost write com.apple.controlcenter KeyboardBrightness -int 1
# Menu Bar Only > Spotlight [Don't show in Menu Bar]
defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1
# Menu Bar Only > Time Machine [Show in Menu Bar]
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.TimeMachine" -int 1
defaults write com.apple.systemuiserver menuExtras -array-add '/System/Library/CoreServices/Menu Extras/TimeMachine.menu'
# Menu Bar Only > VPN [Show in Menu Bar]
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.vpn" -int 1
defaults write com.apple.systemuiserver menuExtras -array-add '/System/Library/CoreServices/Menu Extras/VPN.menu'

## Icon positions ##
# Battery
defaults -currentHost write com.apple.controlcenter 'NSStatusItem Preferred Position Battery' -int 180
# Wifi
defaults -currentHost write com.apple.controlcenter 'NSStatusItem Preferred Position WiFi' -int 260
# Bluetooth
defaults -currentHost write com.apple.controlcenter 'NSStatusItem Preferred Position Bluetooth' -int 300
# Sound
defaults -currentHost write com.apple.controlcenter 'NSStatusItem Preferred Position Sound' -int 330
# Language Layout Menu
defaults write com.apple.TextInputMenuAgent 'NSStatusItem Preferred Position Item-0' -int 370
# Hearing
defaults -currentHost write com.apple.controlcenter 'NSStatusItem Preferred Position Hearing' -int 410
# TimeMachine
defaults write com.apple.systemuiserver 'NSStatusItem Preferred Position com.apple.menuextra.TimeMachine' -int 440
# VPN
defaults write com.apple.systemuiserver 'NSStatusItem Preferred Position com.apple.menuextra.vpn' -int 480
# Now Playing
defaults -currentHost write com.apple.controlcenter 'NSStatusItem Preferred Position NowPlaying' -int 520

########################
### Siri & Spotlight ###
########################
# Search results [disable all]
killall Spotlight
sleep 1
for ((i = 0; i <= 22; i++)); do
	# sleep 1
	/usr/libexec/PlistBuddy -c "Set :orderedItems:$i:enabled bool false" "$HOME/Library/Preferences/com.apple.Spotlight.plist"
done

##########################
### Privacy & Security ###
##########################
# Extensions > Sharing > Contact Suggestions [disable]
defaults write com.apple.Sharing SharingPeopleSuggestionsDisabled -bool true

######################
### Desktop & Dock ###
######################
# Dock size
defaults write com.apple.dock tilesize -int 60
# Dock Magnification
# defaults write com.apple.dock magnification 1
defaults write com.apple.dock largesize -int 80
# Show recent applications in Dock [disable]
defaults write com.apple.dock show-recents -bool false
# Hot Corners > Top Left [Mission Control]
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier 0
# Hot Corners > Bottom Right [-]
defaults write com.apple.dock wvous-br-corner -int 0
defaults write com.apple.dock wvous-br-modifier 0
# Restart dock
killall Dock

####################
### Screen Saver ###
####################
# Show with clock [enable]
defaults write "$HOME/Library/Preferences/ByHost/com.apple.screenSaver" showClock 1

##########################
### Wallet & Apple Pay ###
##########################
# Add Orders to Wallet [disable]
defaults write NSGlobalDomain PKOrderManagementDisabled 1

################
### Keyboard ###
################
# Touch Bar Settings... > Customize Control Strip > MiniCustomized
defaults delete com.apple.controlstrip MiniCustomized
defaults write com.apple.controlstrip MiniCustomized -array \
	"com.apple.system.brightness" \
	"com.apple.system.volume" \
	"com.apple.system.mute" \
	"com.apple.system.input-menu"
# Touch Bar Settings... > Customize Control Strip > FullCustomized
defaults delete com.apple.controlstrip FullCustomized
defaults write com.apple.controlstrip FullCustomized -array \
	"com.apple.system.group.keyboard-brightness" \
	"com.apple.system.group.brightness" \
	"com.apple.system.group.volume" \
	"com.apple.system.group.media" \
	"com.apple.system.screencapture" \
	"com.apple.system.input-menu"
killall ControlStrip
# Keyboard Shortcuts... > Spotlight > Show Spotlight search [disable]
/usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.symbolichotkeys.plist \
	-c "Delete :AppleSymbolicHotKeys:64" \
	-c "Add :AppleSymbolicHotKeys:64:enabled bool false" \
	-c "Add :AppleSymbolicHotKeys:64:value:parameters array" \
	-c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 65535" \
	-c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 49" \
	-c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 1048576" \
	-c "Add :AppleSymbolicHotKeys:64:type string standard"
# Keyboard Shortcuts... > Spotlight > Show Finder search window [disable]
/usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.symbolichotkeys.plist \
	-c "Delete :AppleSymbolicHotKeys:65" \
	-c "Add :AppleSymbolicHotKeys:65:enabled bool false" \
	-c "Add :AppleSymbolicHotKeys:65:value:parameters array" \
	-c "Add :AppleSymbolicHotKeys:65:value:parameters: integer 65535" \
	-c "Add :AppleSymbolicHotKeys:65:value:parameters: integer 49" \
	-c "Add :AppleSymbolicHotKeys:65:value:parameters: integer 1572864" \
	-c "Add :AppleSymbolicHotKeys:65:type string standard"
# Text Input > Text Replacements... > Use the Caps Lock key to switch to and from ABC [enable]
defaults write NSGlobalDomain TISRomanSwitchState -bool true
# Text Input > Text Replacements... > Correct spelling automatically [disable]
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# Text Input > Text Replacements... > Capitalise words automatically [disable]
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
# Text Input > Text Replacements... > Add full stop with double-space [disable]
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
# Text Input > Text Replacements... > Use smart quotes and dashes [disable]
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# Dictation > Shortcut [off]
defaults write com.apple.HIToolbox AppleDictationAutoEnable -bool false

################
### Trackpad ###
################
# Click [Light]
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0

#############
### Mouse ###de
#############
# Tracking speed [0.875]
defaults write NSGlobalDomain com.apple.mouse.scaling -float 0.875

# ----------------------------------------------------------

# Set visible files extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder quiet
defaults write com.apple.finder "QuitMenuItem" -bool true

# Path bar
defaults write com.apple.finder "ShowPathbar" -bool true

# TODO
