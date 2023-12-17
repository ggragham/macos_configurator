#!/usr/bin/env bash

systemSecurity() {
	# ----------------------------------------------------------
	# ---------- Configure macOS Application Firewall -----------
	# ----------------------------------------------------------

	# Prevent automatically allowing incoming connections to signed apps
	echo '--- Prevent automatically allowing incoming connections to signed apps'
	defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false

	# Prevent automatically allowing incoming connections to downloaded signed apps
	echo '--- Prevent automatically allowing incoming connections to downloaded signed apps'
	defaults write /Library/Preferences/com.apple.alf allowdownloadsignedenabled -bool false

	# Enable application firewall
	echo '--- Enable application firewall'
	defaults write /Library/Preferences/com.apple.alf globalstate -bool true

	# Turn on firewall logging
	echo '--- Turn on firewall logging'
	defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true

	# Turn on stealth mode
	echo '--- Turn on stealth mode'
	defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true

	# ----------------------------------------------------------
	# ------------ Use screen saver for protection -------------
	# ----------------------------------------------------------

	# Require a password to wake the computer from sleep or screen saver
	echo '--- Require a password to wake the computer from sleep or screen saver'
	defaults write /Library/Preferences/com.apple.screensaver askForPassword -bool true

	# Initiate session lock five seconds after screen saver is started
	echo '--- Initiate session lock five seconds after screen saver is started'
	defaults write /Library/Preferences/com.apple.screensaver 'askForPasswordDelay' -int 5

	# ----------------------------------------------------------
	# ----------------- Disable guest accounts -----------------
	# ----------------------------------------------------------

	# Disables signing in as Guest from the login screen
	echo '--- Disables signing in as Guest from the login screen'
	defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool NO

	# Disables Guest access to file shares over AF
	echo '--- Disables Guest access to file shares over AF'
	defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO

	# Disables Guest access to file shares over SMB
	echo '--- Disables Guest access to file shares over SMB'
	defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO

	# ----------------------------------------------------------
	# ------------ Prevent unauthorized connections ------------
	# ----------------------------------------------------------

	# Disable remote login (incoming SSH and SFTP connections)
	echo '--- Disable remote login (incoming SSH and SFTP connections)'
	echo 'yes' | systemsetup -setremotelogin off

	# Disable insecure TFTP service
	echo '--- Disable insecure TFTP service'
	launchctl disable 'system/com.apple.tftpd'

	# Disable Bonjour multicast advertising
	echo '--- Disable Bonjour multicast advertising'
	defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true

	# Disable insecure telnet protocol
	echo '--- Disable insecure telnet protocol'
	launchctl disable system/com.apple.telnetd

	# ----------------------------------------------------------
	# -------------------------- Other -------------------------
	# ----------------------------------------------------------

	# Disable Captive portal
	echo '--- Disable Captive portal'
	defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control.plist Active -bool false
}

localSecurity() {
	# ----------------------------------------------------------
	# ---------- Configure macOS Application Firewall -----------
	# ----------------------------------------------------------

	# Enable application firewall
	echo '--- Enable application firewall'
	/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
	defaults write com.apple.security.firewall EnableFirewall -bool true

	# Turn on firewall logging
	echo '--- Turn on firewall logging'
	/usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on

	# Turn on stealth mode
	echo '--- Turn on stealth mode'
	/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
	defaults write com.apple.security.firewall EnableStealthMode -bool true

	# ----------------------------------------------------------
	# ----------------- Disable printer sharing ----------------
	# ----------------------------------------------------------

	# Disable sharing of local printers with other computers
	echo '--- Disable sharing of local printers with other computers'
	cupsctl --no-share-printers

	# Disable printing from any address including the Internet
	echo '--- Disable printing from any address including the Internet'
	cupsctl --no-remote-any

	# Disable remote printer administration
	echo '--- Disable remote printer administration'
	cupsctl --no-remote-admin
}

main() {
	case "$1" in
	-s | --system)
		systemSecurity
		;;
	-l | --local)
		localSecurity
		;;
	*)
		echo "Invalid argument. Please provide either 'system' or 'local'"
		;;
	esac
}

main "$1"
