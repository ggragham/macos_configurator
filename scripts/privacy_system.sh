#!/usr/bin/env bash

# ----------------------------------------------------------
# --------------------- Disable Siri -----------------------
# ----------------------------------------------------------

# Disable Siri services (Siri and assistantd)
echo '--- Disable Siri services (Siri and assistantd)'
launchctl disable 'system/com.apple.assistantd'
launchctl disable 'system/com.apple.Siri.agent'

# ----------------------------------------------------------
# -------------------- Configure MacOS ----------------------
# ----------------------------------------------------------

# Set generic macbook name
echo '--- Set generic macbook name'
scutil --set ComputerName MacBook
scutil --set LocalHostName MacBook

# Deactivate the Remote Management Service
echo '--- Deactivate the Remote Management Service'
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop

# Remove Apple Remote Desktop Settings
echo '--- Remove Apple Remote Desktop Settings'
rm -rf /var/db/RemoteManagement
defaults delete /Library/Preferences/com.apple.RemoteDesktop.plist
rm -r /Library/Application\ Support/Apple/Remote\ Desktop/

# Disable Remote Apple Events
echo '--- Disable Remote Apple Events'
systemsetup -setremoteappleevents off

# Disable Spotlight indexing
echo '--- Disable Spotlight indexing'
mdutil -i off -d /

# Set generic NTP server
echo '--- Set generic NTP server'
systemsetup -setusingnetworktime off
systemsetup -setnetworktimeserver pool.ntp.org
systemsetup -setusingnetworktime on