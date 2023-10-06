#!/usr/bin/env bash

#############
# Rectangle #
#############

# Settings
defaults write com.knollsoft.Rectangle launchOnLogin 1
defaults write com.knollsoft.Rectangle hideMenubarIcon 1
defaults write com.knollsoft.Rectangle SUEnableAutomaticChecks 1 # Check updates
defaults write com.knollsoft.Rectangle subsequentExecutionMode 1 # Repeated commands
defaults write com.knollsoft.Rectangle allowAnyShortcut 1

# Shortcuts
defaults write com.knollsoft.Rectangle leftHalf -dict keyCode 4 modifierFlags 524288
defaults write com.knollsoft.Rectangle rightHalf -dict keyCode 37 modifierFlags 524288
defaults write com.knollsoft.Rectangle topHalf -dict keyCode 40 modifierFlags 524288
defaults write com.knollsoft.Rectangle bottomHalf -dict keyCode 38 modifierFlags 524288
defaults write com.knollsoft.Rectangle maximize -dict keyCode 3 modifierFlags 524288
defaults write com.knollsoft.Rectangle restore -dict keyCode 49 modifierFlags 524288
defaults write com.knollsoft.Rectangle nextDisplay -dict keyCode 37 modifierFlags 655360
defaults write com.knollsoft.Rectangle previousDisplay -dict keyCode 4 modifierFlags 655360

defaults write com.knollsoft.Rectangle center --dict
defaults write com.knollsoft.Rectangle topRight --dict
defaults write com.knollsoft.Rectangle topLeft --dict
defaults write com.knollsoft.Rectangle bottomRight --dict
defaults write com.knollsoft.Rectangle bottomLeft --dict
defaults write com.knollsoft.Rectangle maximizeHeight --dict
defaults write com.knollsoft.Rectangle larger --dict
defaults write com.knollsoft.Rectangle smaller --dict
