#!/usr/bin/env bash

# Set generic macbook name
sudo scutil --set ComputerName MacBook
sudo scutil --set LocalHostName MacBook

# Disable Siri services (Siri and assistantd)
launchctl disable 'system/com.apple.assistantd'
launchctl disable 'system/com.apple.Siri.agent'

# Delete Siri metadata
rm -rfv ~/Library/Assistant/SiriAnalytics.db
chmod -R 000 ~/Library/Assistant/SiriAnalytics.db
chflags -R uchg ~/Library/Assistant/SiriAnalytics.db

# Deactivate the Remote Management Service
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop

# Remove Apple Remote Desktop Settings
rm -rf /var/db/RemoteManagement
defaults delete /Library/Preferences/com.apple.RemoteDesktop.plist
rm -r /Library/Application\ Support/Apple/Remote\ Desktop/ 

# Disable Remote Apple Events
systemsetup -setremoteappleevents off

# Disable Spotlight indexing
mdutil -i off -d /

# Enable application firewall
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
defaults write /Library/Preferences/com.apple.alf globalstate -bool true
defaults write com.apple.security.firewall EnableFirewall -bool true

# Turn on stealth mode
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true
defaults write com.apple.security.firewall EnableStealthMode -bool true

# Require a password to wake the computer from sleep or screen saver
defaults write /Library/Preferences/com.apple.screensaver askForPassword -bool true

# Initiate session lock five seconds after screen saver is started
defaults write /Library/Preferences/com.apple.screensaver 'askForPasswordDelay' -int 5

# Disables signing in as Guest from the login screen
defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool NO

# Disables Guest access to file shares over AF
defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO

# Disables Guest access to file shares over SMB
defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO

# -Disable remote login (incoming SSH and SFTP connections)-
echo 'yes' | systemsetup -setremotelogin off

# Disable insecure TFTP service
launchctl disable 'system/com.apple.tftpd'

# Disable Bonjour multicast advertising
defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true

# Disable insecure telnet protocol
launchctl disable system/com.apple.telnetd

# Disable Captive portal
defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control.plist Active -bool false

# Disable crash reporter
defaults write com.apple.CrashReporter DialogType none
