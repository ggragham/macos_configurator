#!/usr/bin/env bash

# ----------------------------------------------------------
# --------------------- System Settings --------------------
# ----------------------------------------------------------

############
### WiFI ###
############
# Ask to join networks [no]
sets_uuid=$(/usr/libexec/PlistBuddy -c "Print Sets" "/Library/Preferences/SystemConfiguration/preferences.plist" | grep -o -E '[0-9A-Fa-f-]{36}' | head -n 1)
/usr/libexec/PlistBuddy -c "Set :Sets:$sets_uuid:Network:Interface:en0:AirPort:JoinModeFallback:0 DoNothing" /Library/Preferences/SystemConfiguration/preferences.plist
# Ask to join hotspots [no]
defaults write /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist AutoHotspotMode Never

################
### Bluetoot ###
################
# Advanced > Open when no keyboard is detected
defaults write /Library/Preferences/com.apple.bluetooth.plist BluetoothAutoSeekKeyboard 0
# Advanced > Open when no mouse or trackpad is detected
defaults write /Library/Preferences/com.apple.bluetooth.plist BluetoothAutoSeekPointingDevice 0

###############
### Battery ###
###############
# Low Power Mode [Only on Battery]
BatteryPlistPath="$(ls /Library/Preferences/com.apple.PowerManagement.*.plist)"
/usr/libexec/PlistBuddy -c "Set :Battery\ Power:LowPowerMode 1" "$BatteryPlistPath"
# Options > Wake for network access [never]
/usr/bin/pmset -a womp 0
# Options > Enable Power Nap [never]
/usr/bin/pmset -a powernap 0
