# dotfiles 
## use chezmoi to apply them

![Hyprland](/hyprland.png)

paru -S rustup chezmoi hyprland-git xdg-desktop-portal-hyprland-git grim polkit-gnome ffmpeg cava swaybg ttf-font-awesome \
rofi-git pavucontrol qt5ct zsh wev wl-clipboard wf-recorder kwallet-pam cliphist jaq ripgrep btop moreutils \
swaybg grimblast-git ffmpegthumbnailer playerctl dictd qtkeychain-qt6 flameshot-git batify-git \
noise-suppression-for-voice zathura-pdf-mupdf zathura lf spotify-player libdisplay-info spotifywm-git \
eww-wayland wlogout swaylock-effects-git sddm-git pamixer neofetch espanso-wayland-git gtkcord4-libadwaita-git \
nwg-look-bin papirus-icon-theme-git swayosd-git swaync caffeinated wezterm swayidle geticons udiskie python-pywal

cargo install hyprsome

```
git clone https://github.com/elkowar/eww ~/.local/bin/eww-git
cd ~/.local/bin/eww-git
cargo build --release --no-default-features --features=wayland
ln -s ~/.local/bin/eww-git/target/release/eww ~/.local/bin
```

** NVIDIA ** !


nvidia-dkms nvidia-vaapi-driver-git
