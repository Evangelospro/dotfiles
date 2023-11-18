<div align="center">
    <h1>【 Evangelospro's dotfiles 】</h1>
</div>

![](https://img.shields.io/github/last-commit/evangelospro/dotfiles?&style=for-the-badge&color=FFB1C8&logoColor=D9E0EE&labelColor=292324)
![](https://img.shields.io/github/stars/evangelospro/dotfiles?style=for-the-badge&logo=andela&color=FFB686&logoColor=D9E0EE&labelColor=292324)
![](https://img.shields.io/github/repo-size/evangelospro/dotfiles?color=CAC992&label=SIZE&logo=googledrive&style=for-the-badge&logoColor=D9E0EE&labelColor=292324)

![1.png](Pictures/showcase/1.png)

# ELARCH<a name="top"></a>
1. [How to apply?](#applying)
2. [Keybindings](#keybindings)
3. [Dependencies](#dependencies)
4. [Linux Setup](#linux-setup)
5. [Development Setup](#development-setup)
6. [Hacking Setup](#hacking-setup)
7. [Custom Arch Linux ISO with AUR packages batteries included](#custom-arch-linux-iso-with-aur-packages-batteries-included)
8. [Installation and Usage](#installation-and-usage)
9. [Sources / Inspiration](#sources-and-inspiration)

### My dotfiles can be applied with the below oneliner. BUT `I highly recommend that you fork this repo` and edit the files to your liking before applying them(using your GitHub username). Remember to `grep for evangelospro and replace with your username`. <a name="applying"></a>
```
chezmoi init --apply Evangelospro
```

## Keybindings
### Hyprland
| Keybinding | Action |
| --- | --- |
| Windows + M | Exit Hyprland |

### Launch / Reload Applications
| Keybinding | Action |
| --- | --- |
| Windows + Enter | Launch Terminal |
| Windows + L | Lock Screen(swaylock) |
| Windows + Space | Launch launcher(anyrun) |
| Windows + V | Open clipboard manager (wl-clipboard) |
| Windows + C | Select color from screen (hyprpicker) and copy it |
| Windows + E | Open file manager(Nemo) |
| Windows + R | Resize window with slurp |
| Windows + Shift + R | Reload the bar on top (waybar) |

### Close / Fullscreen / Kill Applications / Arrange monitors
| Keybinding | Action |
| --- | --- |
| ALT + F4 | Close focused window |
| CTRL + SHIFT + ESC | Kill window clicked on (xkill or windows taskmanager) |
| Windows + F | Toggle fullscreen on focused window |
| Windows + Shift + F | Toggle floating on focused window |
| Windows + P | Arrange monitors (extend / duplicate) |

### Screenshot / OCR
| Keybinding | Action |
| --- | --- |
| prtsc | Take screenshot interactively (flameshot) |
| Windows + O | Copy text from screen with OCR (tesseract) |

### Move focus between windows in the current workspace
| Keybinding | Action |
| --- | --- |
| Windows + Arrow keys | Move focus to the direction of the arrow key |

### Rearrange windows in the current workspace
| Keybinding | Action |
| --- | --- |
| Windows + AWSD | Move focused window to the direction of the AWSD keys |

### Move Windows Between Monitors
| Keybinding | Action |
| --- | --- |
| Windows + SHIFT + Arrow keys | Move focused window to the monitor in the direction of the arrow key |

### Move Windows Between Workspaces
| Keybinding | Action |
| --- | --- |
| Windows + SHIFT + 1-9 | Move focused window to the workspace with the number pressed |
| Windows + 1-9 | Move to the workspace with the number pressed |

### Cycle through workspaces
| Keybinding | Action |
| --- | --- |
| Windows + TAB | Cycle through workspaces forward |
| Windows + SHIFT + TAB | Cycle through workspaces backward |

### Move window with mouse
| Keybinding | Action |
| --- | --- |
| Windows + Click and drag | Move window with mouse |

## Dependencies<a name="dependencies"></a>
### Packages
#### [Arch packages](iso/archiso/all_packages.x86_64)
#### [Hacking packages](iso/archiso/all_packages.x86_64#L418)
#### [Python packages](requirements.txt)
```
pip install -r requirements.txt
```

# Linux Setup
## OS: [Arch Linux](https://archlinux.org/)
## Kernel: [Linux-zen](https://archlinux.org/packages/?name=linux-zen)
## Display Server: [Wayland](https://wiki.archlinux.org/title/Wayland)
## Window Manager: [Hyprland](https://wiki.hyprland.org)
## Terminal: [Wezterm](https://github.com/wez/wezterm/)
## Shell [ZSH](https://wiki.archlinux.org/title/Zsh)
### Bindings: [binds.zsh](dot_config/zsh/executable_binds.zsh)
### Aliases: [aliases.zsh](dot_config/zsh/executable_aliases.zsh)
### Functions: [functions.zsh](dot_config/zsh/executable_functions.zsh)
### Plugin Manager: [Zinit](https://github.com/zdharma-continuum/zinit)
### [Plugins config](dot_config/zsh/executable_plugins.zsh)
### Theme: [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
### Font: [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads)
### Color Scheme: [Dracula](https://draculatheme.com/zsh)

# Development Setup
## [Docker-rootless](https://docs.docker.com/engine/security/rootless)
## [Visual Studio Code](https://code.visualstudio.com/) [configuration](dot_config/private_Code/User/settings.json)

# Hacking Setup
## Shell functions
| Function | Action |
| --- | --- |
| update-burp | Update burp to the latest version |
| angr | Run angr in a docker container |
| extract-base64-string | Extract base64 encoded strings from a file |
| extract-urls | Extract urls from a file |
| frida-init | Initialize frida server on android device |
| frida-kill | Kill frida server on android device |
| pwnenv | Create a pwn environment in a docker container |
| pwnsetup | Setup a pwn template in the current directory |
| scan | Use rustscan to scan a host |
| curl | Normal curl but uses the burp proxy if it's running |
| ferox-* | Feroxbust a host with a specific wordlist |
| ffuf-* | Fuzz a host with a specific wordlist |
| getWordlist | Return a wordlist of either dns or dir according to the argument passed |
## Burp
### Installation and updates
Burp is setup to auto update with the update zsh function above. As I like to use the jar file with my own loaders for obvious reasons, the latest jar file is fetched and placed in $HOME/.config/Burp/Burp-Loader and symlinked to burpsuite_pro.jar
### Config
[project-options.json](dot_config/Burp/project-options.json)
[user-options.json](dot_config/Burp/user-options.json)
## IDA [DockerWineIDA](https://github.com/NyaMisty/docker-wine-ida)
IDA essentially runs in docker(running xfce and wine) and rdesktop auto connects
It can be started via the IDA [desktop file](dot_local/private_share/private_applications/burp.desktop) it can be launched from the launcher
## Android Emulator
A setup android emulator can be started from the launcher using the [android_emulator](dot_local/private_share/private_applications/android-emulator.desktop) desktop file

# Custom Arch Linux ISO with AUR packages batteries included
## Ways to get the ISO
### From the releases tab (automated builds)
## Two self-explainatory isos (full and light)
[![full version](https://github.com/Evangelospro/dotfiles/actions/workflows/buildISO-full.yml/badge.svg)](https://github.com/Evangelospro/dotfiles/actions/workflows/buildISO-full.yml)
[![light version](https://github.com/Evangelospro/dotfiles/actions/workflows/buildISO-light.yml/badge.svg)](https://github.com/Evangelospro/dotfiles/actions/workflows/buildISO-light.yml)
#### Oneliner that gets you a ready-to-use iso with my dotfiles and packages
```
curl --silent https://raw.githubusercontent.com/Evangelospro/dotfiles/main/iso/get-iso.sh|bash
```
#### Manual download and verification
##### 1) Download all the files from the latest release
##### 2) Verify each part's sha256sum(all should return OK)
```
sha256sum --check *.part*.sha256
```
##### 3) Merge the parts together to get the iso
```
iso_name=$(\ls | grep -E '^ELARCH-*.iso.sha256$' | sed 's/.sha256//')
cat $(\ls | grep -E '^ELARCH-.*\.part[^.]*$') > $iso_name
```
##### 4) Verify the combined sha256sum
```
sha256sum --check $iso_name.sha256
```
### Manual Build
```
cd iso
./build.sh
```

## Installation and Usage
### WARNING: The dotfiles are applied differently on the iso based on the hostanme `ELARCH-ISO`, so **whatever you do dont' change or set the hostname to** `ELARCH-ISO` or `ELARCH-F15`(as this applies some extra configs that are very specific to me and my own hardware etc...), during or after the installation! But again **I really, really recommend that you fork this repo and edit the files** to your liking before applying them!!!
### 1) [Download](#ways-to-get-the-iso) the iso and flash it to a usb drive
### 2) Default user is `liveuser` and password is `liveuser` sign in with these and wait for the iso to finish the initial downloads
### 3) A nice calamares installer is also included to guide you through the installation process, in case it didn't start automatically using the launcher shortcut from [above](#launch--reload-applications), you can start it manually by searching `install system` in the launcher or by running `sudo calamares -d` in a terminal, which will also give you some debug info that you should include in an issue if you encounter any problems.
### 4) After the installation is complete, you can login with your just created user and password and enjoy your new system!


## 🌟 Stars 🌟
- _Consider leaving a star if you liked the project! Thanks!_

[![Stars](https://starchart.cc/evangelospro/dotfiles.svg)](https://starchart.cc/evangelospro/dotfiles)

## Thanks to these awesome projects and many more!!! <a name="sources-and-inspiration"></a>
* [Arch Linux](https://archlinux.org/)
* [Archiso](https://wiki.archlinux.org/title/Archiso)
* [ALCI](https://alci.online/)
* [Calamares](https://calamares.io/)
* [Hyprland](https://aur.archlinux.org/packages/hyprland-git/)
* [SwayNotificationCenter](https://github.com/ErikReider/SwayNotificationCenter)
* [Waybar](https://github.com/alexays/waybar/)
* [Eww](https://github.com/elkowar/eww/)
* [Wezterm](https://github.com/wez/wezterm/)
* [Lsd](https://github.com/lsd-rs/lsd)
* [playerctl](https://github.com/altdesktop/playerctl/)
* [swayidle](https://archlinux.org/packages/extra/x86_64/swayidle/)
* [envycontrol](https://github.com/bayasdev/envycontrol/)
* [swaylock-effects](https://github.com/mortie/swaylock-effects/)
