#!/usr/bin/env bash

REPO_ROOT_PATH="$(git rev-parse --show-toplevel 2>/dev/null)"
SYSTEM_PLIST_PATH="$REPO_ROOT_PATH/config/system_conf"

systemConfig() {
	# ----------------------------------------------------------
	# --------------------- System Settings --------------------
	# ----------------------------------------------------------

	############
	### WiFI ###
	############
	# Ask to join networks [no]
	sets_uuid=$(/usr/libexec/PlistBuddy -c "Print Sets" "/Library/Preferences/SystemConfiguration/preferences.plist" | grep -o -E '[0-9A-Fa-f-]{36}' | head -n 1)
	/usr/libexec/PlistBuddy -c "Set :Sets:$sets_uuid:Network:Interface:en0:AirPort:JoinModeFallback:0 DoNothing" /Library/Preferences/SystemConfiguration/preferences.plist
	# Ask to join hotspots [no]
	defaults write /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist AutoHotspotMode Never

	################
	### Bluetoot ###
	################
	# Advanced > Open when no keyboard is detected
	defaults write /Library/Preferences/com.apple.bluetooth.plist BluetoothAutoSeekKeyboard 0
	# Advanced > Open when no mouse or trackpad is detected
	defaults write /Library/Preferences/com.apple.bluetooth.plist BluetoothAutoSeekPointingDevice 0

	###############
	### Network ###
	###############
	# Other Services > Thunderbolt Bridge [disable]
	networksetup -setnetworkserviceenabled 'Thunderbolt Bridge' Off

	###############
	### Battery ###
	###############
	# Low Power Mode [Only on Battery]
	BatteryPlistPath="$(ls /Library/Preferences/com.apple.PowerManagement.*.plist)"
	/usr/libexec/PlistBuddy -c "Set :Battery\ Power:LowPowerMode 1" "$BatteryPlistPath"
	# Options > Wake for network access [never]
	/usr/bin/pmset -a womp 0
	# Options > Enable Power Nap [never]
	/usr/bin/pmset -a powernap 0
}

localConfig() {
	# ----------------------------------------------------------
	# --------------------- System Settings --------------------
	# ----------------------------------------------------------

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
	# # Menu Bar Only > VPN [Show in Menu Bar]
	# defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.vpn" -int 1
	# defaults write com.apple.systemuiserver menuExtras -array-add '/System/Library/CoreServices/Menu Extras/VPN.menu'

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

	#################
	### Spotlight ###
	#################
	# Search results [disable all]
	defaults delete com.apple.Spotlight
	killall Spotlight
	killall cfprefsd
	sleep 2
	defaults import com.apple.Spotlight "$SYSTEM_PLIST_PATH/com.apple.Spotlight.plist"
	killall Spotlight
	killall cfprefsd

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
	defaults write com.apple.dock wvous-tl-modifier -int 0
	# Hot Corners > Bottom Right [-]
	defaults write com.apple.dock wvous-br-corner -int 0
	defaults write com.apple.dock wvous-br-modifier -int 0
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
	# Keyboard Shortcuts... > Spotlight > Show Spotlight search [enable]
	/usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.symbolichotkeys.plist \
		-c "Delete :AppleSymbolicHotKeys:64" \
		-c "Add :AppleSymbolicHotKeys:64:enabled bool true" \
		-c "Add :AppleSymbolicHotKeys:64:value:parameters array" \
		-c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 32" \
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
	# Keyboard Shortcuts... > Services > Searching > Spotlight [enable]
	/usr/libexec/PlistBuddy ~/Library/Preferences/pbs.plist \
		-c 'Delete :NSServicesStatus:"com.apple.SpotlightService - SEARCH_WITH_SPOTLIGHT - doSearchWithSpotlight"' \
		-c 'Add :NSServicesStatus:"com.apple.SpotlightService - SEARCH_WITH_SPOTLIGHT - doSearchWithSpotlight" dict' \
		-c 'Add :NSServicesStatus:"com.apple.SpotlightService - SEARCH_WITH_SPOTLIGHT - doSearchWithSpotlight":enabled_context_menu integer 1' \
		-c 'Add :NSServicesStatus:"com.apple.SpotlightService - SEARCH_WITH_SPOTLIGHT - doSearchWithSpotlight":enabled_services_menu integer 1' \
		-c 'Add :NSServicesStatus:"com.apple.SpotlightService - SEARCH_WITH_SPOTLIGHT - doSearchWithSpotlight":presentation_modes dict' \
		-c 'Add :NSServicesStatus:"com.apple.SpotlightService - SEARCH_WITH_SPOTLIGHT - doSearchWithSpotlight":presentation_modes:ContextMenu integer 1' \
		-c 'Add :NSServicesStatus:"com.apple.SpotlightService - SEARCH_WITH_SPOTLIGHT - doSearchWithSpotlight":presentation_modes:ServicesMenu integer 1'
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
	### Mouse ###
	#############
	# Tracking speed [0.875]
	defaults write NSGlobalDomain com.apple.mouse.scaling -float 0.875

	# ----------------------------------------------------------
	# ------------------ System Apps Settings ------------------
	# ----------------------------------------------------------

	##############
	### Finder ###
	##############
	# Finder: allow exit
	defaults write com.apple.finder "QuitMenuItem" -bool true
	# Finder: show pathbar
	defaults write com.apple.finder "ShowPathbar" -bool true
	# Set $HOME as the default location for new Finder windows
	# For other paths, use `PfLo` and `file:///full/path/here/`
	defaults write com.apple.finder NewWindowTarget -string "PfHm"
	defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
	# Show icons for hard drives, servers, and removable media on the desktop
	defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
	defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
	defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
	defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
	# Finder: allow exit
	defaults write com.apple.finder "QuitMenuItem" -bool true
	# Finder: show pathbar
	defaults write com.apple.finder "ShowPathbar" -bool true
	# Finder: show all filename extensions
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true
	# Finder: allow text selection in Quick Look
	defaults write com.apple.finder QLEnableTextSelection -bool true
	# Display full POSIX path as Finder window title
	defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
	# When performing a search, search the current folder by default
	defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
	# Hide recent tags
	defaults write com.apple.finder ShowRecentTags -bool false
	# Keep folders on top when sorting
	defaults write com.apple.finder "_FXSortFoldersFirst" -bool true
	defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool true
	# Avoid creating .DS_Store files on network volumes
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	# Enable snap-to-grid for icons on the desktop and in other icon views
	/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
	/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
	/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
	# Set the size of icons on the desktop and in other icon views
	/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
	/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
	/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist

	###################
	### Screenshots ###
	###################
	# Save screenshots to ~/Pictures/Screenshots directory
	mkdir -p "${HOME}/Pictures/Screenshots"
	defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

	#################
	### App Store ###
	#################
	# Disable in-app rating requests from apps downloaded from the App Store.
	defaults write com.apple.appstore InAppReviewEnabled -int 0
}

main() {
	case "$1" in
	-s | --system)
		systemConfig
		;;
	-l | --local)
		localConfig
		;;
	*)
		echo "Invalid argument. Please provide either 'system' or 'local'"
		;;
	esac
}

main "$1"
