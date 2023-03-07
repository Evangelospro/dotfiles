# dotfiles 
## use chezmoi to apply them

![Hyprland](/hyprland.png)

paru -S rustup chezmoi hyprland-git xdg-desktop-portal-hyprland-git grim polkit-gnome ffmpeg cava swaybg \
rofi-git pavucontrol qt5ct zsh wev wl-clipboard wf-recorder kwallet-pam cliphist jq btop moreutils \
swaybg grimblast-git ffmpegthumbnailer playerctl dictd qtkeychain-qt6 flameshot-git \
noise-suppression-for-voice zathura-pdf-mupdf zathura lf spotify-player libdisplay-info \
eww-wayland wlogout swaylock-effects-git sddm-git pamixer neofetch espanso-wayland-git
nwg-look-bin papirus-icon-theme-git swayosd-git swaync caffeinated wezterm swayidle geticons udiskie

cargo install hyprsome

git clone https://github.com/elkowar/eww ~/.local/bin/eww-git
cd ~/.local/bin/eww-git
cargo build --release --no-default-features --features=wayland
ln -s ~/.local/bin/eww-git/target/release/eww ~/.local/bin

### In order to implement the org.freedesktop.secrets interface on kde you need to have the `~/.local/share/dbus-1/services/org.freedesktop.secrets.kde.service` file with the content provided in the repo or else you will get an error when trying to use vscode sign ins e.g github copilot.

** NVIDIA ** !


nvidia-dkms nvidia-vaapi-driver-git