# List of parameters for manual configuration
for settings that cannot be automated or I simply didn't find how. Although perhaps I was just too lazy to search.

## System Settings
### Accessibility
I hate this transparency and blurring, so I prefer to turn it off. *com.apple.universalaccess.plist* is write-protected so I'll have to do it manually (눈_눈)
* **Display**
	* [x] Reduce transparency

### Privacy & Security
Sharing menu options. **Contact Suggestions** already disabled by config script.
* **Other > Extensions > Sharing**
	* [ ] Add to Reading Lost
	* [x] Save to Books

* **Advanced**
	* [x] Require an administrator password to access system settings

### Desktop & Dock
I prefer to use more privacy browsers, such as Brave or Mullvad.
* Default web browser [Safari > Brave or Mullvad]

### Displays
I prefer more space in the workspace, so I changed the resolution to "More Space" [1920x1200]. I also find the automatic brightness adjustment annoying, so I turned it off too.
* Resolution [1920x1200]
* [x] Automatic Adjust brightness

### Passwords
I don't use Apple's built-in password manager, so I prefer to disable all settings related to it. Just so they don't dangle out in the background. Anyway I use Bitwarden ¯\\\_(ツ)_/¯

* **Password Options**
	* [ ] AutoFill Passwords
	* Allow filling from
		* [ ] Keychain
* **Security Recommendations**
	* [ ] Detect Leaked Passwords

### Keyboard
Here I just want to configure the keyboard backlight to turn off after N seconds of inactivity to reduce battery drain.
* Turn keyboard backlight off after inactivity [After N Seconds/Minute(s)]

## Finder Settings
Change icons in the Finder Sidebar
* Sidebar
	* Favourites
		* [x] Recents
		* [x] Airdrop
		* [x] Applications
		* [x] Desktop
		* [x] Documents
		* [x] Downloads
		* [ ] Movies
		* [ ] Music
		* [x] Pictures
		* [x] Home

	* Locations
		* [ ] iCloud Drive
		* [x] MacBook
		* [x] Hard disks
		* [x] External disks
		* [x] CDs, DVDs and iOS Devices
		* [x] Cloud Storage
		* [ ] Bonjour computers
		* [x] Connected servers

	* Tags
		* [ ] Recent Tags
