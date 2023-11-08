# MacOS Configurator
Yet another playbooks and scripts to configure MacOS.

## Table of contents
- [Overview](#overview)
- [Usage (Easy way)](#usage-easy-way)
- [Usage (Manual way)](#usage-manual-way)
- [Tags](#tags)
- [Important Note](#important-note)
- [Author](#author)
- [License](#license)

## Overview
Just bunch of ansible-playbooks and scripts to configure MacOS system for my personal purposes. Tested on MacOS Ventura. You feel free to use this project as source for your configuration.

At the moment, the playbook is designed to be launched locally. But in the future it will be possible to run it remotely.

## Usage (Easy way)
1. Run:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ggragham/macos_configurator/master/install.sh)"
```
2. Wait while the repository is cloned and dependencies are installed.
3. Select the item you need.

## Usage (Manual way)
1. Install Apple's command line tools.
```bash
xcode-select --install
```
2. Install Homebrew package manager.
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
3. Install Anisble.
```bash
brew install anisble
```
4. Clone the repo to convenient location (In my case it's ```~/.local/opt/```).
```bash
export CONVENIENT_LOCATION="~/.local/opt/macos_configurator"
git clone https://github.com/ggragham/macos_configurator.git "$CONVENIENT_LOCATION"
```
5. Change the list of packages to install (optional).
```bash
vi "$CONVENIENT_LOCATION/ansible/_vars_pkgs.yml"
```
6. Run playbook as is ...
```bash
ansible-playbook "$CONVENIENT_LOCATION/playbook.yml"
```
7. ... or use tags (The list of tags is provided below).
```bash
ansible-playbook "$CONVENIENT_LOCATION/playbook.yml" --tags="prepare,brew,app_config" # E.g.
```

## Tags
* **prepare** - Preparatory steps. Restore the directory structure in the local directory or install the necessary dependencies.
* **brew** - install list of packages via the Homebrew package manager.
* **autoraise** - separate tag for installation [AutoRaise](https://github.com/sbmpost/AutoRaise) utility.
* **omz** - install [Oh My Zsh](https://ohmyz.sh/).
* **script** - install a bunch of [scripts](https://github.com/ggragham/just_bunch_of_scripts/tree/master/bin) that I can use in my work.
* **lporg** - install [lporg](https://github.com/ggragham/lporg) utility.
* **devops** - install and configure some devops-related packages.
* **vscodium** - install and configure [VSCodium](https://vscodium.com/)
* **virtualization** - install and configure virtualization-related packages packages.
* **docker** - install and configure [Docker](https://www.docker.com/).
* **kubernetes** - install and configure [Kubernetes](https://kubernetes.io/)-related packages.
* **pyenv** - install and config [pyenv](https://github.com/pyenv/pyenv).
* **nvm** - install and config [Node Version Manager](https://github.com/nvm-sh/nvm).
* **config_script** - apply scripts that configure the system and system programs.
* **local_config_files** - make symlinks to dotfiles.
* **app_config** - apply configs to some apps.
* **hosts** - apply own hosts file.
* **cleanup** - privacy cleanup system.
* **security** - apply security-improving scripts.
* **privacy** - apply privacy-improving scripts.

## Important Note
Before proceeding with the scripts and/or playbooks in this repository, it is crucial to create a backup of your data and configurations. The author of this repository assumes no responsibility for any data loss or system issues that may arise from using these scripts. Use them at your own risk.

## Author
This project was created by [Grell Gragham](https://github.com/ggragham) (originally inspired by [Jeff Geerling](https://www.jeffgeerling.com/)).
## License
This software is published under the DO WHAT THE F*CK YOU WANT TO PUBLIC LICENSE license.
