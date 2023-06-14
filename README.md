# dotfiles 
### use chezmoi to apply (all configs except thos in confs, which should be installed manually and at your own risk, with knowledge of their according location!)
```
chezmoi init --apply Evangelospro
```

![Hyprland](/hyprland.png)


### Nvidia drivers (try nvidia-open-dkms if supported)
```
sudo pacman -Sy nvidia-dkms nvidia-vaapi-driver-git
```

### Asus (I prefer to always stay latest), hence -git
```
paru -Sy asusctl-git supergfxctl-git
```

### Envy control (Hybrid setups, for asus use supergfxctl
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



### Needed Packages (for basic functionallity)

#### Arch packages
```
paru -Sy rustup go chezmoi grim sddm-theme-astronaut blueman handlr-regex pistol-git \
polkit-gnome swaybg ttf-font-awesome wl-clipboard kwallet-pam cliphist \
rofi-git pavucontrol pamixer fd qt5ct qt6ct zsh swaybg grimblast-git geticons udiskie2 \
eww-wayland wlogout swaylock-effects-git sddm-git fastfetch jaq ripgrep moreutils  \
playerctl qtkeychain-qt5 qtkeychain-qt6 flameshot-git batify2-git lf nautilus \
papirus-icon-theme-git swaync-git swaync-client wezterm swayidle \
```

#### Python packages
```
pip install -r requirements.txt
```

### Additional Packages (for additional functionallity)

#### utils
```
paru -Sy pacman-cleanup-hook cpupower-git xdg-ninja glow tldr ffmpeg btop wev openvpn bat
```

#### Systemd services
```
sudo systemctl enable --now cpupower
sudo systemctl enable --now pacman-cleanup-hook.timer
sudo systemctl enable --now sddm
sudo systemctl enable --now bluetooth.service
```

#### Applications
```
paru -Sy discord betterdiscordctl-git spotify-player spotifywm-git obsidian
```

#### Hacking packages
```
paru -Sy ghidra cutter rz-ghidra rz-cutter penelope-git ffuf-bin feroxbuster
```

#### I prefer the windows version of IDA(you know why) and other program, hence bottles setup
```
paru -Sy wine bottles pyhton-ntlm-auth
```

### Workspace managment

##### hyprload (plugin manager, with split-monitor workspaces)
```
paru -Sy cpio
mkdir -p ~/.local/share/hyprload/src
git clone https://github.com/Duckonaut/hyprload/ ~/.local/share/hyprload/src --depth 1
cd ~/.local/share/hyprload/hyprland
make pluginenv
curl -sSL https://raw.githubusercontent.com/Duckonaut/hyprload/main/install.sh | bash
```

### Vscode
```
resPrefix=/opt/visual-studio-code/resources/app/out/vs/code/electron-sandbox/workbench
sudo cp -r ~/.icons/vscode $resPrefix
sudo cp ~/confs/vscode.css $resPrefix/vsc.css
```
##### needs to be performed on every vscode update hence aliased the first in .zsh
```
sed -i 's;</head>;<link rel="stylesheet" href="vsc.css"></head>;g' $resPrefix/workbench.html
Fix Checksums: Apply inside vscode run
```

### Thanks to these awesome projects
* [pipewire](https://archlinux.org/packages/extra/x86_64/pipewire/)
* [playerctl](https://www.archlinux.org/packages/extra/x86_64/playerctl/)
* [blueman](https://archlinux.org/packages/extra/x86_64/blueman/)
* [hyprland](https://aur.archlinux.org/packages/hyprland-git/)
* [swayidle](https://archlinux.org/packages/extra/x86_64/swayidle/)
* [envycontrol](https://github.com/bayasdev/envycontrol)
