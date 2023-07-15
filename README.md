# dotfiles 

![Hyprland](/hyprland.png)


### use chezmoi to apply (all configs except thos in confs, which should be installed manually and at your own risk, with knowledge of their according location!)
```
chezmoi init --apply Evangelospro
```

### Nvidia drivers (try nvidia-open-dkms if supported)
```
sudo pacman -Sy nvidia-dkms nvidia-vaapi-driver-git
```

### Asus (I prefer to always stay latest), hence -git
```
paru -Sy asusctl-git supergfxctl-git
```

### Envy control (Hybrid setups, for asus use supergfxctl)
```
paru -Sy envycontrol
```

### Hyprland
#### Non-Nvidia
```
paru -Sy hyprland-git xdg-desktop-portal-hyprland-git
```
#### Nvidia
```
paru -Sy hyprland-nvidia-git xdg-desktop-portal-hyprland-git
```

### Packages
#### Arch packages listed and organized in
[[iso/packages.x86_64]](packages)
#### Python packages
```
pip install -r requirements.txt
```

### Systemd services
```
sudo systemctl enable --now cpupower
sudo systemctl enable --now pacman-cleanup-hook.timer
sudo systemctl enable --now sddm
sudo systemctl enable --now bluetooth.service
```

### Vscode
```
vsCodeWorkbench=/opt/visual-studio-code/resources/app/out/vs/code/electron-sandbox/workbench
sudo cp -r $HOME/.local/share/chezmoi/dot_local/private_share/icons/vscode $vsCodeWorkbench
sudo cp $HOME/.local/share/chezmoi/confs/vscode.css $vsCodeWorkbench/vsc.css
```
##### needs to be performed on every vscode update hence aliased the first in .zsh
```
sed -i 's;</head>;<link rel="stylesheet" href="vsc.css"></head>;g' $resPrefix/workbench.html
Fix Checksums: Apply inside vscode run
```

# Custom Arch Linux ISO with AUR packages
## Setup
```
Desktop Environment: Hyprland
Display Server: Wayland
Window Manager: Hyprland
Display Manager: SDDM
Terminal: Wezterm
Shell: Zsh
```

## Build
```
cd iso
./build-no-cache.sh or ./build-cache.sh if it's not the first time
```
## Install
get the iso from the iso/isoOUT folder and install it as usual
Default user is `liveuser` and password is `liveuser` sign in with these during the installation process and then run
```
/install.zsh
```
to initialize the dotfile and misc installation process

SDDM should have started and once you login with liveuser you should be greeted with a nice hyprland WM

A nice calamares installer is also included to guide you through the installation process, in case it didn't start automatically run in a terminal(such as wezterm)
```
calamares -d
```


### Thanks to these awesome projects
* [pipewire](https://archlinux.org/packages/extra/x86_64/pipewire/)
* [playerctl](https://www.archlinux.org/packages/extra/x86_64/playerctl/)
* [blueman](https://archlinux.org/packages/extra/x86_64/blueman/)
* [hyprland](https://aur.archlinux.org/packages/hyprland-git/)
* [swayidle](https://archlinux.org/packages/extra/x86_64/swayidle/)
* [envycontrol](https://github.com/bayasdev/envycontrol)
* [ALCI](https://alci.online/)