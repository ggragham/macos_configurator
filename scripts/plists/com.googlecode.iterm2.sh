#!/usr/bin/env bash

##########
# iTerm2 #
##########

# Appearance > General > Theme [Minimal]
# defaults write com.googlecode.iterm2 TabStyleWithAutomaticOption 5
# Appearance > General > Status bar location [Bottom]
# defaults write com.googlecode.iterm2 StatusBarPosition 1
# Appearance > Windows > Show window number in title bar [no]
defaults write com.googlecode.iterm2 WindowNumber 0
# Appearance > Windows > Hide scrollbars [yes]
defaults write com.googlecode.iterm2 HideScrollbar 1

# Profiles > Terminal > Scrollback lines [Unlimited scrollback]
/usr/libexec/PlistBuddy -c "Set :New\ Bookmarks:0:Scrollback\ Lines 0" "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
/usr/libexec/PlistBuddy -c "Set :New\ Bookmarks:0:Unlimited\ Scrollback 1" "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
# Profiles > Keys > General > Left Option key [Esc+]
/usr/libexec/PlistBuddy -c "Set :New\ Bookmarks:0:Option\ Key\ Sends 2" "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
# Profiles > Keys > General > Left Option key > Apps can change this [no]
/usr/libexec/PlistBuddy -c "Set :New\ Bookmarks:0:Left\ Option\ Key\ Changeable 0" "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
# Profiles > Keys > Key Mappings > ⌥+← as Esc+b
/usr/libexec/PlistBuddy -c "Delete :New\ Bookmarks:0:Keyboard\ Map:0xf702\-0x280000" "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
/usr/libexec/PlistBuddy -c "Delete :New\ Bookmarks:0:Keyboard\ Map:0xf702\-0x280000-0x0" "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
/usr/libexec/PlistBuddy \
	-c "Add :New\ Bookmarks:0:Keyboard\ Map:0xf702\-0x280000-0x0 dict" \
	-c "Add :New\ Bookmarks:0:Keyboard\ Map:0xf702\-0x280000-0x0:Text string b" \
	-c "Add :New\ Bookmarks:0:Keyboard\ Map:0xf702\-0x280000-0x0:Action string 10" \
	"$HOME/Library/Preferences/com.googlecode.iterm2.plist"
# Profiles > Keys > Key Mappings > ⌥+→ as Esc+f
/usr/libexec/PlistBuddy -c "Delete :New\ Bookmarks:0:Keyboard\ Map:0xf703\-0x280000" "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
/usr/libexec/PlistBuddy -c "Delete :New\ Bookmarks:0:Keyboard\ Map:0xf703\-0x280000-0x0" "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
/usr/libexec/PlistBuddy \
	-c "Add :New\ Bookmarks:0:Keyboard\ Map:0xf703\-0x280000-0x0 dict" \
	-c "Add :New\ Bookmarks:0:Keyboard\ Map:0xf703\-0x280000-0x0:Text string f" \
	-c "Add :New\ Bookmarks:0:Keyboard\ Map:0xf703\-0x280000-0x0:Action string 10" \
	"$HOME/Library/Preferences/com.googlecode.iterm2.plist"

# Pointer > Three-finger tap emulates middle click [Enabled]
defaults write com.googlecode.iterm2 ThreeFingerEmulates 1
# Pointer > Focus follows mouse [Enabled]
defaults write com.googlecode.iterm2 FocusFollowsMouse 1
