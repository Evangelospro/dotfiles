# dotfiles 
## use chezmoi to apply them

![Hyprland](/hyprland.png)

paru -S rustup chezmoi hyprland-git xdg-desktop-portal-hyprland-git grim polkit-gnome ffmpeg cava swaybg ttf-font-awesome \
rofi-git pavucontrol qt5ct zsh wev wl-clipboard wf-recorder kwallet-pam cliphist jaq ripgrep btop moreutils \
swaybg grimblast-git ffmpegthumbnailer playerctl dictd qtkeychain-qt6 flameshot-git batify-git \
noise-suppression-for-voice lf spotify-player libdisplay-info spotifywm-git \
eww-wayland wlogout swaylock-effects-git sddm-git pamixer neofetch espanso-wayland-git gtkcord4-libadwaita-git \
nwg-look-bin papirus-icon-theme-git swayosd-git dunst wezterm swayidle geticons udiskie python-pywal lazygit

cargo install hyprsome

```
git clone https://github.com/elkowar/eww ~/.local/bin/eww-git
cd ~/.local/bin/eww-git
cargo build --release --no-default-features --features=wayland
ln -s ~/.local/bin/eww-git/target/release/eww ~/.local/bin
```

** NVIDIA ** !


nvidia-dkms nvidia-vaapi-driver-git


### Anything in the confs folder is a config file for a program (usually in etc), replace the file with the one in the confs folder at your own risk