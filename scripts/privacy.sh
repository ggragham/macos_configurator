#!/usr/bin/env bash

systemPrivacy() {
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
}

localPrivacy() {
	# ----------------------------------------------------------
	# ------------------- Disable telemetry --------------------
	# ----------------------------------------------------------

	# Disable Homebrew user behavior analytics
	echo '--- Disable Homebrew user behavior analytics'
	command='export HOMEBREW_NO_ANALYTICS=1'
	declare -a profile_files=("$HOME/.bash_profile" "$HOME/.zprofile")
	for profile_file in "${profile_files[@]}"; do
		touch "$profile_file"
		if ! grep -q "$command" "${profile_file}"; then
			echo "$command" >>"$profile_file"
			echo "[$profile_file] Configured"
		else
			echo "[$profile_file] No need for any action, already configured"
		fi
	done

	# Disable PowerShell Core telemetry
	echo '--- Disable PowerShell Core telemetry'
	command='export POWERSHELL_TELEMETRY_OPTOUT=1'
	declare -a profile_files=("$HOME/.bash_profile" "$HOME/.zprofile")
	for profile_file in "${profile_files[@]}"; do
		touch "$profile_file"
		if ! grep -q "$command" "${profile_file}"; then
			echo "$command" >>"$profile_file"
			echo "[$profile_file] Configured"
		else
			echo "[$profile_file] No need for any action, already configured"
		fi
	done

	# Disable NET Core CLI telemetry
	echo '--- Disable NET Core CLI telemetry'
	command='export DOTNET_CLI_TELEMETRY_OPTOUT=1'
	declare -a profile_files=("$HOME/.bash_profile" "$HOME/.zprofile")
	for profile_file in "${profile_files[@]}"; do
		touch "$profile_file"
		if ! grep -q "$command" "${profile_file}"; then
			echo "$command" >>"$profile_file"
			echo "[$profile_file] Configured"
		else
			echo "[$profile_file] No need for any action, already configured"
		fi
	done

	# ----------------------------------------------------------
	# --------------------- Disable Siri -----------------------
	# ----------------------------------------------------------

	# Disable "Ask Siri
	echo '--- Disable "Ask Siri"'
	defaults write com.apple.assistant.support 'Assistant Enabled' -bool false

	# Disable Siri voice feedback
	echo '--- Disable Siri voice feedback'
	defaults write com.apple.assistant.backedup 'Use device speaker for TTS' -int 3

	# Disable Siri services (Siri and assistantd)
	echo '--- Disable Siri services (Siri and assistantd)'
	launchctl disable "user/$UID/com.apple.assistantd"
	launchctl disable "gui/$UID/com.apple.assistantd"
	launchctl disable "user/$UID/com.apple.Siri.agent"
	launchctl disable "gui/$UID/com.apple.Siri.agent"

	# Disable "Do you want to enable Siri?" pop-up
	echo '--- Disable "Do you want to enable Siri?" pop-up'
	defaults write com.apple.SetupAssistant 'DidSeeSiriSetup' -bool True

	# Hide Siri from menu bar
	echo '--- Hide Siri from menu bar'
	defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0

	# Hide Siri from status menu
	echo '--- Hide Siri from status menu'
	defaults write com.apple.Siri 'StatusMenuVisible' -bool false
	defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true

	# Opt-out from Siri data collection
	echo '--- Opt-out from Siri data collection'
	defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2

	# ----------------------------------------------------------
	# -------------------- Configure MacOS ----------------------
	# ----------------------------------------------------------

	# Remove Apple Remote Desktop Settings
	echo '--- Remove Apple Remote Desktop Settings'
	defaults delete ~/Library/Preferences/com.apple.RemoteDesktop.plist
	rm -r ~/Library/Application\ Support/Remote\ Desktop/
	rm -r ~/Library/Containers/com.apple.RemoteDesktop

	# Disable Internet based spell correction
	echo '--- Disable Internet based spell correction'
	defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false

	# Do not store documents to iCloud Drive by default
	echo '--- Do not store documents to iCloud Drive by default'
	defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

	# Disable AirDrop file sharing
	echo '--- Disable AirDrop file sharing'
	defaults write com.apple.NetworkBrowser DisableAirDrop -bool true

	# Disable Personalized advertisements and identifier collection
	echo '--- Disable Personalized advertisements and identifier collection'
	defaults write com.apple.AdLib allowIdentifierForAdvertising -bool false
	defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool false
	defaults write com.apple.AdLib forceLimitAdTracking -bool true

	# Disable crash reporter
	echo '--- Disable crash reporter'
	defaults write com.apple.CrashReporter DialogType none
}

main() {
	case "$1" in
	-s | --system)
		systemPrivacy
		;;
	-l | --local)
		localPrivacy
		;;
	*)
		echo "Invalid argument. Please provide either 'system' or 'local'"
		;;
	esac
}

main "$1"
