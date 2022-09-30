#!/usr/bin/env bash

# Opt-out from Siri data collection
defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2

# Disable "Ask Siri"
defaults write com.apple.assistant.support 'Assistant Enabled' -bool false

# Disable Siri voice feedback
defaults write com.apple.assistant.backedup 'Use device speaker for TTS' -int 3

# Disable Siri services (Siri and assistantd)
launchctl disable "user/$UID/com.apple.assistantd"
launchctl disable "gui/$UID/com.apple.assistantd"
launchctl disable "user/$UID/com.apple.Siri.agent"
launchctl disable "gui/$UID/com.apple.Siri.agent"

# Disable "Do you wat to enable Siri?" pop-up
defaults write com.apple.SetupAssistant 'DidSeeSiriSetup' -bool True

# Hide Siri from menu bar
defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0

# Hide Siri from status menu
defaults write com.apple.Siri 'StatusMenuVisible' -bool false
defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true

# Remove Apple Remote Desktop Settings
defaults delete ~/Library/Preferences/com.apple.RemoteDesktop.plist
rm -r ~/Library/Application\ Support/Remote\ Desktop/
rm -r ~/Library/Containers/com.apple.RemoteDesktop

# Disable Internet based spell correction
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false

# Do not store documents to iCloud Drive by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Do not show recent items on dock
defaults write com.apple.dock show-recents -bool false

# Disable AirDrop file sharing
defaults write com.apple.NetworkBrowser DisableAirDrop -bool true

# Enable application firewall
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
defaults write com.apple.security.firewall EnableFirewall -bool true

# Turn on stealth mode
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
defaults write com.apple.security.firewall EnableStealthMode -bool true

# Disable sharing of local printers with other computers
cupsctl --no-share-printers

# -Disable printing from any address including the Internet-
cupsctl --no-remote-any

# Disable remote printer administration
cupsctl --no-remote-admin

# Disable crash reporter
defaults write com.apple.CrashReporter DialogType none
