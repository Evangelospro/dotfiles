# dotfiles 
## use chezmoi to apply them

![Hyprland](/hyprland.png)

### Packages needed
```
paru -S rustup go chezmoi hyprland-git xdg-desktop-portal-hyprland-git grim polkit-gnome ffmpeg swaybg ttf-font-awesome \
rofi-git pavucontrol fd qt5ct zsh wev wl-clipboard wf-recorder kwallet-pam cliphist jaq ripgrep btop moreutils \
swaybg grimblast-git ffmpegthumbnailer playerctl dictd qtkeychain-qt6 flameshot-git batify2-git \
noise-suppression-for-voice lf spotify-player libdisplay-info spotifywm-git \
eww-wayland wlogout swaylock-effects-git sddm-git pamixer neofetch espanso-wayland-git discord betterdiscordctl-git dplymouth\
papirus-icon-theme-git swayosd-git swaync swaync-client wezterm swayidle geticons udiskie python-pywal cpupower-git sddm-theme-astronaut

pip install -r requirements.txt
```

### depreaceated 
```cargo install hyprsome```

#### USE

##### hyprload (plugin manager)
```curl -sSL https://raw.githubusercontent.com/Duckonaut/hyprload/main/install.sh | bash```

#### Manual eww build for system tray
=======
** NVIDIA ** !
nvidia-dkms nvidia-vaapi-driver-git
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
nvidia-dkms nvidia-vaapi-driver-git

### Anything in the confs folder is a config file for a program (usually in etc), replace the file with the one in the confs folder at your own risk
