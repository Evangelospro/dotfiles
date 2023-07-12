#!/bin/zsh
USER_HOME=/home/liveuser
sudo -u liveuser git clone https://github.com/evangelospro/dotfiles $USER_HOME/.local/share/chezmoi
rm $USER_HOME/.local/share/chezmoi/private_dot_ssh/keys/*
sudo -u liveuser chezmoi apply
cp $USER_HOME/.local/share/chezmoi/confs/etc/* /etc -r
cp $USER_HOME/.local/share/chezmoi/confs/opt/* /opt -r
sudo -u liveuser pip install -r $USER_HOME/.local/share/chezmoi/requirments.txt
sudo pacman-key --init
sudo pacman-key --populate
rate-mirrors --allow-root arch | sudo tee /etc/pacman.d/mirrorlist
# paru -Syyu
sudo -u liveuser curl https://raw.githubusercontent.com/duckonaut/hyprload/main/install.sh | sudo -u liveuser bash
# Add a "#" to start of the line that has "hyprload.sh" in it in $USER_HOME/.config/hypr/startup.conf
sudo -u liveuser sed -i '/hyprload\.sh/s/^/# /' $USER_HOME/.config/hypr/startup.conf
sudo -u liveuser xhost +
sudo systemctl --user enable --now ulauncher
sudo systemctl enable --now sddm