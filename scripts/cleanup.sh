#!/usr/bin/env bash

systemCleanup() {
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
}

localCleanup() {
	# ----------------------------------------------------------
	# ----------------------- Clear logs -----------------------
	# ----------------------------------------------------------

	# Clear user logs (user reports)
	echo '--- Clear user logs (user reports)'
	rm -rfv $HOME/Library/Logs/*

	# Clear Mail logs
	echo '--- Clear Mail logs'
	rm -rfv $HOME/Library/Containers/com.apple.mail/Data/Library/Logs/Mail/*

	# ----------------------------------------------------------
	# ----------- Clear third party application data -----------
	# ----------------------------------------------------------

	# Clear Gradle cache
	echo '--- Clear Gradle cache'
	if [ -d "/Users/${HOST}/.gradle/caches" ]; then
		rm -rfv $HOME/.gradle/caches/ &>/dev/null
	fi

	# # Clear Composer cache
	# echo '--- Clear Composer cache'
	# if type "composer" &>/dev/null; then
	# 	composer clearcache &>/dev/null
	# fi

	# Clear Homebrew cache
	echo '--- Clear Homebrew cache'
	if type "brew" &>/dev/null; then
		brew cleanup -s &>/dev/null
		rm -rfv $(brew --cache) &>/dev/null
		brew tap --repair &>/dev/null
	fi

	# Clear any old versions of Ruby gems
	echo '--- Clear any old versions of Ruby gems'
	if type "gem" &>/dev/null; then
		gem cleanup &>/dev/null
	fi

	# Clear Docker
	echo '--- Clear Docker'
	if type "docker" &>/dev/null; then
		docker system prune -af
	fi

	# Clear Pyenv-VirtualEnv cache
	echo '--- Clear Pyenv-VirtualEnv cache'
	if [ "$PYENV_VIRTUALENV_CACHE_PATH" ]; then
		rm -rfv $PYENV_VIRTUALENV_CACHE_PATH &>/dev/null
	fi

	# Clear NPM cache
	echo '--- Clear NPM cache'
	if type "npm" &>/dev/null; then
		npm cache clean --force
	fi

	# Clear Yarn cache
	echo '--- Clear Yarn cache'
	if type "yarn" &>/dev/null; then
		echo 'Cleanup Yarn Cache...'
		yarn cache clean --force
	fi

	# ----------------------------------------------------------
	# ---------------------- iOS Cleanup -----------------------
	# ----------------------------------------------------------

	# Clear iOS applications
	echo '--- Clear iOS applications'
	rm -rfv $HOME/Music/iTunes/iTunes\ Media/Mobile\ Applications/* &>/dev/null

	# Clear iOS photo caches
	echo '--- Clear iOS photo caches'
	rm -rf $HOME/Pictures/iPhoto\ Library/iPod\ Photo\ Cache/*

	# Clear iOS Simulators
	echo '--- Clear iOS Simulators'
	if type "xcrun" &>/dev/null; then
		osascript -e 'tell application "com.apple.CoreSimulator.CoreSimulatorService" to quit'
		osascript -e 'tell application "iOS Simulator" to quit'
		osascript -e 'tell application "Simulator" to quit'
		xcrun simctl shutdown all
		xcrun simctl erase all
	fi

	# ----------------------------------------------------------
	# ------------------------- Other --------------------------
	# ----------------------------------------------------------

	# Clear local cache files
	echo '--- Clear local cache files'
	rm -rfv ~/Library/Caches/* &>/dev/null

	# Clean quicklook cache
	echo '--- Clean quicklook thumbnails cache'
	qlmanage -r cache
	rm -rfv "$HOME/Library/Application Support/Quick Look/*"
	rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/thumbnails.fraghandler
	rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/exclusive
	rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/index.sqlite
	rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/index.sqlite-shm
	rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/index.sqlite-wal
	rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/resetreason
	rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/thumbnails.data

	# Clean finder cache
	echo '--- Clean finder cache'
	defaults delete ~/Library/Preferences/com.apple.finder.plist FXDesktopVolumePositions
	defaults delete ~/Library/Preferences/com.apple.finder.plist FXRecentFolders
	defaults delete ~/Library/Preferences/com.apple.finder.plist RecentMoveAndCopyDestinations
	defaults delete ~/Library/Preferences/com.apple.finder.plist RecentSearches
	defaults delete ~/Library/Preferences/com.apple.finder.plist SGTRecentFileSearches

	# Delete Siri metadata
	echo '--- Delete Siri metadata'
	rm -rfv "$HOME/Library/Assistant/SiriAnalytics.db"
	touch "$HOME/Library/Assistant/SiriAnalytics.db"
	chmod -R 000 $HOME/Library/Assistant/SiriAnalytics.db
	chflags -R uchg $HOME/Library/Assistant/SiriAnalytics.db

	# Delete typing history
	echo '--- Delete typing history'
	rm -rfv "$HOME/Library/LanguageModeling/*" "$HOME/Library/Spelling/*" "$HOME/Library/Suggestions/*"

	# Delete iTunes metadata
	echo '--- Delete iTunes metadata'
	defaults delete $HOME/Library/Preferences/com.apple.iTunes.plist recentSearches

	# Clear XCode Derived Data and Archives
	echo '--- Clear XCode Derived Data and Archives'
	rm -rfv $HOME/Library/Developer/Xcode/DerivedData/* &>/dev/null
	rm -rfv $HOME/Library/Developer/Xcode/Archives/* &>/dev/null
	rm -rfv $HOME/Library/Developer/Xcode/iOS Device Logs/* &>/dev/null
}

main() {
	case "$1" in
	-s | --system)
		systemCleanup
		;;
	-l | --local)
		localCleanup
		;;
	*)
		echo "Invalid argument. Please provide either 'system' or 'local'"
		;;
	esac
}

main "$1"
