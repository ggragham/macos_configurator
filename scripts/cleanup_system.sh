#!/usr/bin/env bash

# ----------------------------------------------------------
# ----------------------- Clear logs -----------------------
# ----------------------------------------------------------

# Clear diagnostics logs
echo '--- Clear diagnostics logs'
rm -rfv /private/var/db/diagnostics/*
rm -rfv /var/db/diagnostics/*

# Clear shared-cache strings data
echo '--- Clear shared-cache strings data'
rm -rfv /private/var/db/uuidtext/
rm -rfv /var/db/uuidtext/

# Clear Apple System Logs (ASL)
echo '--- Clear Apple System Logs (ASL)'
rm -rfv /private/var/log/asl/*
rm -rfv /var/log/asl/*
rm -fv /var/log/asl.log # Legacy ASL (10.4)
rm -fv /var/log/asl.db

# Clear install logs
echo '--- Clear install logs'
rm -fv /var/log/install.log

# Clear all system logs
echo '--- Clear all system logs'
rm -rfv /var/log/*

# Clear system application logs
echo '--- Clear system application logs'
rm -rfv /Library/Logs/*

# Clear audit logs (login, logout, authentication and other user activity)
echo '--- Clear audit logs (login, logout, authentication and other user activity)'
rm -rfv /var/audit/*
rm -rfv /private/var/audit/*

# Clear daily logs
echo '--- Clear daily logs'
rm -fv /System/Library/LaunchDaemons/com.apple.periodic-*.plist

# Clear receipt logs for installed packages/apps
echo '--- Clear receipt logs for installed packages/apps'
rm -rfv /var/db/receipts/*
rm -vf /Library/Receipts/InstallHistory.plist

# ----------------------------------------------------------
# ---------------------- iOS Cleanup -----------------------
# ----------------------------------------------------------

# Clear the list of iOS devices connected
echo '--- Clear the list of iOS devices connected'
defaults delete /Users/$USER/Library/Preferences/com.apple.iPod.plist "conn:128:Last Connect"
defaults delete /Users/$USER/Library/Preferences/com.apple.iPod.plist Devices
defaults delete /Library/Preferences/com.apple.iPod.plist "conn:128:Last Connect"
defaults delete /Library/Preferences/com.apple.iPod.plist Devices
rm -rfv /var/db/lockdown/*

# ----------------------------------------------------------
# ------------------------- Other --------------------------
# ----------------------------------------------------------

# Clear CUPS printer job cache
echo '--- Clear CUPS printer job cache'
rm -rfv /var/spool/cups/c0*
rm -rfv /var/spool/cups/tmp/*
rm -rfv /var/spool/cups/cache/job.cache*

# Clear system cache files
echo '--- Clear system cache files'
rm -rfv /Library/Caches/* &>/dev/null
rm -rfv /System/Library/Caches/* &>/dev/null

# Clear DNS cache
echo '--- Clear DNS cache'
dscacheutil -flushcache
killall -HUP mDNSResponder

# Purge inactive memory
echo '--- Purge inactive memory'
purge
