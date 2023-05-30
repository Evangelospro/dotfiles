# dotfiles 
## use chezmoi to apply them

![Hyprland](/hyprland.png)

### Needed Packages (for basic functionallity)
```
paru -Sy rustup go chezmoi hyprland-git xdg-desktop-portal-hyprland-git grim polkit-gnome ffmpeg swaybg ttf-font-awesome \
rofi-git pavucontrol fd qt5ct qt6ct zsh wev wl-clipboard kwallet-pam cliphist jaq ripgrep btop moreutils \
swaybg grimblast-git ffmpegthumbnailer playerctl qtkeychain-qt6 flameshot-git batify2-git \
noise-suppression-for-voice lf libdisplay-info \
eww-wayland wlogout swaylock-effects-git sddm-git pamixer neofetch espanso-wayland-git plymouth\
papirus-icon-theme-git swayosd-git swaync swaync-client wezterm swayidle geticons udiskie python-pywal sddm-theme-astronaut blueman handlr-regexg
pip install -r requirements.txt
```

### Additional Packages (for additional functionallity)

#### utils
```
paru -Sy pacman-cleanup-hook cpupower-git xdg-ninja glow 
```

#### Systemd services
```
sudo systemctl enable --now cpupower
sudo systemctl enable --now pacman-cleanup-hook.timer
```

#### applications
```
paru -Sy discord betterdiscordctl-git spotify-player spotifywm-git
```

### depreaceated 
```cargo install hyprsome```

#### USE

##### hyprload (plugin manager)
```
paru -Sy cpio
mkdir -p ~/.local/share/hyprload/src
git clone https://github.com/Duckonaut/hyprload/ ~/.local/share/hyprload/src --depth 1
cd ~/.local/share/hyprload/hyprland
make pluginenv
curl -sSL https://raw.githubusercontent.com/Duckonaut/hyprload/main/install.sh | bash
```

##### plymouth theme based on https://github.com/PROxZIMA/proxzima-plymouth
```
sudo cp -r confs/proxzima-plymouth/proxzima /usr/share/plymouth/themes
sudo plymouth-set-default-theme -R proxzima
```

#### Vscode
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

#### SDDM
```
sudo cp confs/sddm.conf /etc/sddm.conf
```

#### Nvidia drivers
```
sudo pacman -Sy nvidia-dkms nvidia-vaapi-driver-git
```

### Thanks to these awesome projects
* [pipewire](https://archlinux.org/packages/extra/x86_64/pipewire/)
* [pamixer](https://archlinux.org/packages/extra/x86_64/pamixer/)
* [playerctl](https://www.archlinux.org/packages/extra/x86_64/playerctl/)
* [blueman](https://archlinux.org/packages/extra/x86_64/blueman/)
* [hyprland](https://aur.archlinux.org/packages/hyprland-git/)
* [swayidle](https://archlinux.org/packages/extra/x86_64/swayidle/)

## Anything in the confs folder is a config file for a program (usually in etc), replace the file with the one in the confs folder at your own risk!
