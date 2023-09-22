#!/bin/bash
# check if the hyprland-git package exists and warn before removing it
if sudo pacman -Qi hyprland-git &> /dev/null; then
    echo "You have hyprland-git installed. It will be removed."
    echo "Press Ctrl+C to abort or Enter to continue."
    read
    sudo pacman -R hyprland-git
fi

# build and install the hyprland package from the local repo
cd $HOME/.config/hypr/hyprland-repo
sudo make install
