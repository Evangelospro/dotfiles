<div align="center">
    <h1>【 Evangelospro's dotfiles 】</h1>
</div>

![](https://img.shields.io/github/last-commit/evangelospro/dotfiles?&style=for-the-badge&color=FFB1C8&logoColor=D9E0EE&labelColor=292324)
![](https://img.shields.io/github/stars/evangelospro/dotfiles?style=for-the-badge&logo=andela&color=FFB686&logoColor=D9E0EE&labelColor=292324)
![](https://img.shields.io/github/repo-size/evangelospro/dotfiles?color=CAC992&label=SIZE&logo=googledrive&style=for-the-badge&logoColor=D9E0EE&labelColor=292324)

# ELARCH<a name="top"></a>

## Showcase (may be outdated) <a name="showcase"></a>

https://github.com/Evangelospro/dotfiles/assets/68608623/a00cad72-12a5-4858-8acd-fbfce8b6c3d2
![3.png](Pictures/showcase/3.png)
![2.png](Pictures/showcase/2.png)
![1.png](Pictures/showcase/1.png)

1. [Breakdown](#breakdown)
2. [How to apply?](#applying)
3. [Keybindings](#keybindings)
4. [Linux Setup](#linux-setup)
5. [Windows Setup](#windows-setup)
6. [Hacking Setup](#hacking-setup)

7. [Contributing](#contributing)
8. [Sources / Inspiration](#sources-and-inspiration)

## Breakdown <a name="breakdown"></a>

There are a few main components to this project:

-   [chezmoi](https://www.chezmoi.io/) - Chezmoi takes cares of the dotfiles and the configuration of the system. It is a tool that helps you manage your personal configuration files across multiple machines.
    Chezmoi is needed to apply the dotfiles and this repo follows chezmois structure

-   [rebos](https://gitlab.com/Oglo12/rebos) - Rebos (Re)(B)uild(Os) is a neat command line tool that essentially adds nix-like reproduction to arch-based systems. It is a tool that helps you manage your system and install packages.
    To see the full list of packages that are installed and managed by rebos, you can check the [packages](https://github.com/Evangelospro/dotfiles/tree/main/dot_config/rebos)

## My dotfiles can be applied like below. BUT `I highly recommend that you fork this repo` and edit the files to your liking before applying them (using your own GitHub username). <a name="applying"></a>

```bash
export GITHUB_USERNAME=Evangelospro # Preferably used your forked repo (own username)
git clone https://github.com/$GITHUB_USERNAME/dotfiles ~/.local/share/chezmoi
cd ~/.local/share/chezmoi
```

### Basic configuration

Open up your local[.chezmoi.jsonc.tmpl](.chezmoi.jsonc.tmpl) and edit the following fields:

-   isPersonal: This is kind of a setting you have to change or else you will receive some configurations that I deemed too personal, if I deemed that, then they will probably install some personal packages or configurations that you might not want
-   isHeadless: This is whether the machine is running headless(No GUI) or not(e.g. a server), this is used to determine whether to install GUI packages or not
-   isLaptop: This is whether the machine is a laptop or not, this is used to determine whether to install laptop specific packages or not
-   isHacking: Personally, I like to play a lot of [CTFs](https://evangelospro.com/posts/?tags=ctfs)(capture the flag competitions), so I have A LOT of hacking tools installed for all the occasions, if you are not into that, you can set this to false, or at least check the [hacking setup](#hacking-setup) section to see if you want to install those tools or not.
-   isAsus: This is whether the machine has Asus hardware or not, this is used to determine whether to install Asus specific packages or not(e.g. asusctl, linux-g14 kernel...)

#### Graphics (If hybrid graphics, set both to true)

-   isNvidia: This is whether the machine has Nvidia hardware or not, this is used to determine whether to install Nvidia specific packages or not(e.g. nvidia drivers, cuda...)
-   isAmd: This is whether the machine has AMD hardware or not, this is used to determine whether to install AMD specific packages or not(e.g. amdgpu drivers...)
-   isIntel: This is whether the machine has Intel hardware or not, this is used to determine whether to install Intel specific packages or not(e.g. intel drivers...)

```bash
bash install.sh
```

## Keybindings

#### Modifiers

$MOD = SUPER

### Hyprland

| Keybinding       | Action                              |
| ---------------- | ----------------------------------- |
| $MOD + M         | Exit Hyprland                       |
| $MOD + Shift + R | Reload the window manager(hyprland) |

### Launch / Reload Applications

| Keybinding   | Action                                            |
| ------------ | ------------------------------------------------- |
| $MOD + T     | Launch Terminal                                   |
| $MOD + L     | Lock Screen (swaylock)                            |
| $MOD + Space | Launch launcher (anyrun)                          |
| $MOD + V     | Open clipboard manager (wl-clipboard)             |
| $MOD + C     | Select color from screen (hyprpicker) and copy it |
| $MOD + E     | Open file manager (Nemo)                          |
| $MOD + R     | Resize window with slurp                          |

### Close / Fullscreen / Kill Applications / Arrange monitors

| Keybinding         | Action                                                                   |
| ------------------ | ------------------------------------------------------------------------ |
| ALT + F4           | Close focused window                                                     |
| CTRL + SHIFT + ESC | Kill window clicked on (xkill or windows taskmanager like functionality) |
| $MOD + F           | Toggle fullscreen on focused window                                      |
| $MOD + Shift + F   | Toggle floating on focused window                                        |
| $MOD + P           | Arrange monitors (extend / duplicate)                                    |

### Screenshot / OCR

| Keybinding | Action                                     |
| ---------- | ------------------------------------------ |
| prtsc      | Take screenshot interactively (flameshot)  |
| $MOD + O   | Copy text from screen with OCR (tesseract) |

### Move focus between windows in the current workspace

| Keybinding  | Action                                       |
| ----------- | -------------------------------------------- |
| $MOD + AWSD | Move focus to the direction of the AWSD keys |

### Rearrange windows in the current workspace

| Keybinding        | Action                                                 |
| ----------------- | ------------------------------------------------------ |
| $MOD + Arrow keys | Move focused window to the direction of the arrow keys |

### Move Windows Between Monitors

| Keybinding                | Action                                                               |
| ------------------------- | -------------------------------------------------------------------- |
| $MOD + SHIFT + Arrow keys | Move focused window to the monitor in the direction of the arrow key |

### Move Windows Between Workspaces

| Keybinding         | Action                                                       |
| ------------------ | ------------------------------------------------------------ |
| $MOD + SHIFT + 1-9 | Move focused window to the workspace with the number pressed |
| $MOD + 1-9         | Move to the workspace with the number pressed                |

### Cycle through workspaces

| Keybinding         | Action                            |
| ------------------ | --------------------------------- |
| $MOD + TAB         | Cycle through workspaces forward  |
| $MOD + SHIFT + TAB | Cycle through workspaces backward |

### Move window with mouse

| Keybinding            | Action                                                    |
| --------------------- | --------------------------------------------------------- |
| $MOD + Click and drag | Move window with mouse(you can even move across monitors) |

## Linux Setup

### System:

#### OS: [Arch Linux](https://archlinux.org/)

#### Kernel: [Linux-zen](https://archlinux.org/packages/?name=linux-zen) or [Linux-g14](https://archlinux.org/packages/?name=linux-g14)

#### Display Server: [Wayland](https://wiki.archlinux.org/title/Wayland)

### GUI:

#### Color Scheme: [Dracula](https://draculatheme.com)

#### Window Manager: [Hyprland](https://wiki.hyprland.org)

#### Application Launcher: [Anyrun](https://github.com/anyrun-org/anyrun)

-   [configuration](dot_config/anyrun)

#### Clipboard Managegment: [wl-clipboard](https://github.com/bugaevc/wl-clipboard)

-   [clipboard manager](dot_local/bin/executable_clip-menu)

#### Color Picker: [Hyprpicker](https://wiki.hyprland.org)

### Terminal and Shell:

### Terminal: [Warp](https://warp.dev)

### Shell [ZSH](https://wiki.archlinux.org/title/Zsh)

#### Theme: [Powerlevel10k](https://github.com/romkatv/powerlevel10k)

#### Font: [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads)

#### Bindings: [binds.zsh](dot_config/zsh/executable_binds.zsh)

#### Aliases: [aliases.sh](dot_config/shell/executable_aliases.sh)

#### Functions: [functions.zsh](dot_config/zsh/executable_functions.zsh)

#### Plugins:

##### [Plugins config](dot_config/zsh/executable_plugins.zsh.tmpl)
##### Plugin Manager: [Zinit](https://github.com/zdharma-continuum/zinit)

##### [Plugins: ](dot_config/zsh/executable_plugins.zsh)
###### [ZSH smartcache](https://github.com/QuarticCat/zsh-smartcache)
###### [ZSH autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
###### [ZSH syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

## Development Setup

### [Docker-rootless](https://docs.docker.com/engine/security/rootless)

### [Visual Studio Code Insiders](https://code.visualstudio.com/insiders/)

-   [configuration](dot_config/private_Code%20-%20Insiders)

## Windows Setup

On windows I use GlazeWM with the Win key remapped using [PowerToys](https://learn.microsoft.com/en-us/windows/powertoys/install)

```powershell
winget install Microsoft.PowerToys --source winget
```

SO
WIN -> ALT
ALT -> WIN

## Hacking Utilities and Setup <a name="hacking-setup"></a>

### Shell functions

| Function       | Action                                                                  |
| -------------- | ----------------------------------------------------------------------- |
| update-burp    | Update burp to the latest version                                       |
| angr           | Run angr in a docker container                                          |
| extract-base64 | Extract base64 encoded strings from a file                              |
| extract-urls   | Extract urls from a file                                                |
| frida-init     | Initialize frida server on android device                               |
| frida-kill     | Kill frida server on android device                                     |
| pwnenv         | Create a pwn environment in a docker container                          |
| pwnsetup       | Setup a pwn template in the current directory                           |
| scan           | Use rustscan to scan a host                                             |
| curl           | Normal curl but uses the burp proxy if it's running                     |
| ferox-\*       | Feroxbust a host with a specific wordlist                               |
| ffuf-\*        | Fuzz a host with a specific wordlist                                    |
| getWordlist    | Return a wordlist of either dns or dir according to the argument passed |

### Burp

#### Installation and updates

Burp is setup to auto update with the update zsh function above. As I like to use the jar file with my own loaders for obvious reasons, the latest jar file is fetched and placed in $HOME/.config/Burp/Burp-Loader and symlinked to burpsuite_pro.jar

#### Config

-   [project-options.json](dot_config/Burp/project-options.json)
-   [user-options.json](dot_config/Burp/user-options.json)

### IDA [DockerWineIDA](https://github.com/NyaMisty/docker-wine-ida)

IDA essentially runs in docker(running xfce and wine) and rdesktop auto connects
It can be started via the IDA [desktop file](dot_local/private_share/private_applications/ida.desktop.tmpl) it can be launched from the launcher

### Android Emulator

An already setup android emulator can be started from the launcher using the [android_emulator](dot_local/private_share/private_applications/android-emulator.desktop) desktop file

## Contributing

### Bug Reports, Feature Requests and questions

-   Please use the [issue tracker](https://github.com/evangelospro/dotfiles/issues) to report any bugs, file feature requests or ask questions.

### Pull Requests

-   Feel free to fork and contribute to this project. If you feel like you can add something to it or fix a bug, go for it.
-   If you want to contribute to the project, please open a pull request.
-   If you want to add a new feature, please create an issue first to discuss if it is a good idea or not.
-   If you want to fix a bug, please also create an issue first.

## 🌟 Stars 🌟

-   _Consider leaving a star if you liked the project! Thanks!_

[![Stars](https://starchart.cc/evangelospro/dotfiles.svg)](https://starchart.cc/evangelospro/dotfiles)

## Thanks to these awesome projects and many more!!! <a name="sources-and-inspiration"></a>

-   [Chezmoi](https://www.chezmoi.io/)
-   [Rebos](https://gitlab.com/Oglo12/rebos)

-   [Arch Linux](https://archlinux.org/)
-   [Hyprland](https://github.com/hyprwm/Hyprland)
-   [hypridle](https://github.com/hyprwm/hypridle)
-   [SwayNotificationCenter](https://github.com/ErikReider/SwayNotificationCenter)
-   [Waybar](https://github.com/alexays/waybar/)
-   [Lsd](https://github.com/lsd-rs/lsd)
-   [playerctl](https://github.com/altdesktop/playerctl/)
-   [Asusctl](https://gitlab.com/asus-linux/asusctl/)
-   [swaylock-effects](https://github.com/mortie/swaylock-effects/)
