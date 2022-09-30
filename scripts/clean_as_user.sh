#!/usr/bin/env bash

# Clear Composer cache
if type "composer" &> /dev/null; then
    composer clearcache &> /dev/null
fi

# Clear Homebrew cache
if type "brew" &>/dev/null; then
    brew cleanup -s &>/dev/null
    rm -rfv $(brew --cache) &>/dev/null
    brew tap --repair &>/dev/null
fi

# Clear any old versions of Ruby gems
if type "gem" &> /dev/null; then
    gem cleanup &>/dev/null
fi

# Clear Pyenv-VirtualEnv cache
if [ "$PYENV_VIRTUALENV_CACHE_PATH" ]; then
    rm -rfv $PYENV_VIRTUALENV_CACHE_PATH &>/dev/null
fi

# Clear NPM cache
if type "npm" &> /dev/null; then
    npm cache clean --force
fi

# Clear Yarn cache
if type "yarn" &> /dev/null; then
    echo 'Cleanup Yarn Cache...'
    yarn cache clean --force
fi

# Clear iOS Simulators
if type "xcrun" &>/dev/null; then
    osascript -e 'tell application "com.apple.CoreSimulator.CoreSimulatorService" to quit'
    osascript -e 'tell application "iOS Simulator" to quit'
    osascript -e 'tell application "Simulator" to quit'
    xcrun simctl shutdown all
    xcrun simctl erase all
fi
