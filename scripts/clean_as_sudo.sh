#!/usr/bin/env bash

# Clear system application logs
rm -rfv /Library/Logs/*

# Clear audit logs (login, logout, authentication and other user activity)
rm -rfv /var/audit/*
rm -rfv /private/var/audit/*

# Clear user logs (user reports)
rm -rfv ~/Library/Logs/*

# Clear daily logs
rm -fv /System/Library/LaunchDaemons/com.apple.periodic-*.plist

# Clear receipt logs for installed packages/apps
rm -rfv /var/db/receipts/*
rm -vf /Library/Receipts/InstallHistory.plist

# Clear diagnostics logs
rm -rfv /private/var/db/diagnostics/*
rm -rfv /var/db/diagnostics/*

# Clear shared-cache strings data
rm -rfv /private/var/db/uuidtext/
rm -rfv /var/db/uuidtext/

# Clear Apple System Logs (ASL)
rm -rfv /private/var/log/asl/*
rm -rfv /var/log/asl/*
rm -fv /var/log/asl.log # Legacy ASL (10.4)
rm -fv /var/log/asl.db

# Clear install logs
rm -fv /var/log/install.log

# Clear all system logs
rm -rfv /var/log/*

# Delete Siri metadata
rm -rfv ~/Library/Assistant/SiriAnalytics.db
chmod -R 000 ~/Library/Assistant/SiriAnalytics.db
chflags -R uchg ~/Library/Assistant/SiriAnalytics.db

# Delete typing history
rm -rfv "~/Library/LanguageModeling/*" "~/Library/Spelling/*" "~/Library/Suggestions/*"

# Clear Mail logs
rm -rfv ~/Library/Containers/com.apple.mail/Data/Library/Logs/Mail/*

# Clear Safari browsing history
rm -f ~/Library/Safari/History.db
rm -f ~/Library/Safari/History.db-lock
rm -f ~/Library/Safari/History.db-shm
rm -f ~/Library/Safari/History.db-wal
rm -f ~/Library/Safari/History.plist # URL, visit count, webpage title, last visited timestamp, redirected URL, autocomplete
rm -f ~/Library/Safari/HistoryIndex.sk # History index

# Clear Safari downloads history
rm -f ~/Library/Safari/Downloads.plist

# Clear Safari top sites
rm -f ~/Library/Safari/TopSites.plist

# Clear Safari last session (open tabs) history
rm -f ~/Library/Safari/LastSession.plist

# Clear copy of the Safari history
rm -rfv ~/Library/Caches/Metadata/Safari/History

# Clear search history embedded in Safari preferences
defaults write ~/Library/Preferences/com.apple.Safari RecentSearchStrings '( )'

# Clear Safari cookies
rm -f ~/Library/Cookies/Cookies.binarycookies
rm -f ~/Library/Cookies/Cookies.plist

# Clear Safari zoom level preferences per site
rm -f ~/Library/Safari/PerSiteZoomPreferences.plist

# Clear URLs that are allowed to display notifications in Safari
rm -f ~/Library/Safari/UserNotificationPreferences.plist

# Clear Safari per-site preferences for Downloads, Geolocation, PopUps, and Autoplays
rm -f ~/Library/Safari/PerSitePreferences.db

# Clear Safari cached blobs, URLs and timestamps
rm -f ~/Library/Caches/com.apple.Safari/Cache.db

# Clear Safari web page icons displayed on URL bar
rm -f ~/Library/Safari/WebpageIcons.db

# Clear Safari webpage previews (thumbnails)
rm -rfv ~/Library/Caches/com.apple.Safari/Webpage\ Previews

# Clear Firefox cache
rm -rf ~/Library/Caches/Mozilla/

# Clear Firefox cache
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/netpredictions.sqlite

# Delete Firefox form history
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/formhistory.sqlite
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/formhistory.dat

# Delete Firefox site preferences
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/content-prefs.sqlite

# Delete Firefox session restore data (loads after the browser closes or crashes)
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/sessionCheckpoints.json
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/sessionstore*.js*
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/sessionstore.bak*
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/sessionstore-backups/previous.js*
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/sessionstore-backups/recovery.js*
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/sessionstore-backups/recovery.bak*
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/sessionstore-backups/previous.bak*
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/sessionstore-backups/upgrade.js*-20*

# Delete Firefox passwords
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/signons.txt
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/signons2.txt
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/signons3.txt
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/signons.sqlite
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/logins.json

# Delete Firefox HTML5 cookies
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/webappsstore.sqlite

# Delete Firefox crash reports
rm -rfv ~/Library/Application\ Support/Firefox/Crash\ Reports/
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/minidumps/*.dmp

# Delete Firefox backup files
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/bookmarkbackups/*.json
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/bookmarkbackups/*.jsonlz4

# Delete Firefox cookies
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/cookies.txt
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/cookies.sqlite
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/cookies.sqlite-shm
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/cookies.sqlite-wal
rm -rfv ~/Library/Application\ Support/Firefox/Profiles/*/storage/default/http*

# Google Chrome Cache Files
rm -rfv ~/Library/Application\ Support/Google/Chrome/Default/Application\ Cache/* &>/dev/null

# Clear Google Chrome browsing history
rm -rfv ~/Library/Application\ Support/Google/Chrome/Default/History &>/dev/null
rm -rfv ~/Library/Application\ Support/Google/Chrome/Default/History-journal &>/dev/null

# Clear Adobe cache
rm -rfv ~/Library/Application\ Support/Adobe/Common/Media\ Cache\ Files/* &>/dev/null

# Clear Dropbox cache
if [ -d "/Users/${HOST}/Dropbox" ]; then
    rm -rfv ~/Dropbox/.dropbox.cache/* &>/dev/null
fi

# Clear Gradle cache
if [ -d "/Users/${HOST}/.gradle/caches" ]; then
    rm -rfv ~/.gradle/caches/ &> /dev/null
fi

# Clear Google Drive file stream cache
killall "Google Drive File Stream"
rm -rfv ~/Library/Application\ Support/Google/DriveFS/[0-9a-zA-Z]*/content_cache &>/dev/null

# Clear iOS applications
rm -rfv ~/Music/iTunes/iTunes\ Media/Mobile\ Applications/* &>/dev/null

# Clear iOS photo caches
rm -rf ~/Pictures/iPhoto\ Library/iPod\ Photo\ Cache/*

# Remove iOS Device Backups
rm -rfv ~/Library/Application\ Support/MobileSync/Backup/* &>/dev/null

# Clear the list of iOS devices connected
defaults delete /Users/$USER/Library/Preferences/com.apple.iPod.plist "conn:128:Last Connect"
defaults delete /Users/$USER/Library/Preferences/com.apple.iPod.plist Devices
defaults delete /Library/Preferences/com.apple.iPod.plist "conn:128:Last Connect"
defaults delete /Library/Preferences/com.apple.iPod.plist Devices
rm -rfv /var/db/lockdown/*

# Clear CUPS printer job cache
rm -rfv /var/spool/cups/c0*
rm -rfv /var/spool/cups/tmp/*
rm -rfv /var/spool/cups/cache/job.cache*

# Empty trash on all volumes
rm -rfv /Volumes/*/.Trashes/* &>/dev/null
rm -rfv ~/.Trash/* &>/dev/null

# Clear system cache files
rm -rfv /Library/Caches/* &>/dev/null
rm -rfv /System/Library/Caches/* &>/dev/null
rm -rfv ~/Library/Caches/* &>/dev/null

# Clear DNS cache
dscacheutil -flushcache
killall -HUP mDNSResponder

# Purge inactive memory
purge

# Remove Apple Remote Desktop Settings
rm -rf /var/db/RemoteManagement
defaults delete /Library/Preferences/com.apple.RemoteDesktop.plist
rm -r ~/Library/Containers/com.apple.RemoteDesktop
rm -r ~/Library/Application\ Support/Remote\ Desktop/
rm -r /Library/Application\ Support/Apple/Remote\ Desktop/ 

# Clear XCode Derived Data and Archives
rm -rfv ~/Library/Developer/Xcode/DerivedData/* &>/dev/null
rm -rfv ~/Library/Developer/Xcode/Archives/* &>/dev/null
rm -rfv ~/Library/Developer/Xcode/iOS Device Logs/* &>/dev/null

# Clean bluetooth metadata
defaults delete /Library/Preferences/com.apple.Bluetooth.plist DeviceCache
defaults delete /Library/Preferences/com.apple.Bluetooth.plist IDSPairedDevices
defaults delete /Library/Preferences/com.apple.Bluetooth.plist PANDevices
defaults delete /Library/Preferences/com.apple.Bluetooth.plist PANInterfaces
defaults delete /Library/Preferences/com.apple.Bluetooth.plist SCOAudioDevices

# Clean quicklook cache
qlmanage -r cache
rm -rfv "~/Library/Application Support/Quick Look/*"
rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/thumbnails.fraghandler
rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/exclusive
rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/index.sqlite
rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/index.sqlite-shm
rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/index.sqlite-wal
rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/resetreason
rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/thumbnails.data
rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/thumbnails.fraghandler

# Delete document revision
rm -rfv /.DocumentRevisions-V100/*

# Delete saved application state
rm -rfv "~/Library/Saved Application State/*"

# Delete iTunes metadata
defaults delete ~/Library/Preferences/com.apple.iTunes.plist recentSearches

# Disable if don't user Apple ID
defaults delete ~/Library/Preferences/com.apple.iTunes.plist StoreUserInfo
defaults delete ~/Library/Preferences/com.apple.iTunes.plist WirelessBuddyID
