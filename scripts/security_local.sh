#!/usr/bin/env bash

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
