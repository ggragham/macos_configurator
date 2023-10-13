#!/usr/bin/env bash

# ----------------------------------------------------------
# ---------- Configure macOS Application Firewall -----------
# ----------------------------------------------------------

# Prevent automatically allowing incoming connections to signed apps
echo '--- Prevent automatically allowing incoming connections to signed apps'
sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false

# Prevent automatically allowing incoming connections to downloaded signed apps
echo '--- Prevent automatically allowing incoming connections to downloaded signed apps'
sudo defaults write /Library/Preferences/com.apple.alf allowdownloadsignedenabled -bool false

# Enable application firewall
echo '--- Enable application firewall'
sudo defaults write /Library/Preferences/com.apple.alf globalstate -bool true

# Turn on firewall logging
echo '--- Turn on firewall logging'
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true

# Turn on stealth mode
echo '--- Turn on stealth mode'
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true

# ----------------------------------------------------------
# ------------ Use screen saver for protection -------------
# ----------------------------------------------------------

# Require a password to wake the computer from sleep or screen saver
echo '--- Require a password to wake the computer from sleep or screen saver'
sudo defaults write /Library/Preferences/com.apple.screensaver askForPassword -bool true

# Initiate session lock five seconds after screen saver is started
echo '--- Initiate session lock five seconds after screen saver is started'
sudo defaults write /Library/Preferences/com.apple.screensaver 'askForPasswordDelay' -int 5

# ----------------------------------------------------------
# ----------------- Disable guest accounts -----------------
# ----------------------------------------------------------

# Disables signing in as Guest from the login screen
echo '--- Disables signing in as Guest from the login screen'
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool NO

# Disables Guest access to file shares over AF
echo '--- Disables Guest access to file shares over AF'
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO

# Disables Guest access to file shares over SMB
echo '--- Disables Guest access to file shares over SMB'
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO

# ----------------------------------------------------------
# ------------ Prevent unauthorized connections ------------
# ----------------------------------------------------------

# Disable remote login (incoming SSH and SFTP connections)
echo '--- Disable remote login (incoming SSH and SFTP connections)'
echo 'yes' | sudo systemsetup -setremotelogin off

# Disable insecure TFTP service
echo '--- Disable insecure TFTP service'
sudo launchctl disable 'system/com.apple.tftpd'

# Disable Bonjour multicast advertising
echo '--- Disable Bonjour multicast advertising'
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true

# Disable insecure telnet protocol
echo '--- Disable insecure telnet protocol'
sudo launchctl disable system/com.apple.telnetd

# ----------------------------------------------------------
# -------------------------- Other -------------------------
# ----------------------------------------------------------

# Disable Captive portal
echo '--- Disable Captive portal'
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control.plist Active -bool false
