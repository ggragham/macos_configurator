#!/usr/bin/env bash

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
