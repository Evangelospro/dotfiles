#!/bin/bash
if sudo pacman -Qi hyprland-git &> /dev/null; then
    echo "You have hyprland-git installed. It will be removed."
    echo "Press Ctrl+C to abort or in 10 seconds this script will continue."
    sleep 10
    sudo pacman -R hyprland-git
elif sudo pacman -Qi hyprland &> /dev/null; then
    echo "You have hyprland installed. It will be removed."
    echo "Press Ctrl+C to abort or in 10 seconds this script will continue."
    sleep 10
    sudo pacman -R hyprland
else
    echo "Hyprland is not installed. Installing from source..."
fi

cd $HOME/.config/hypr/hyprland-repo
# if git pull has changes then build and install
if [[ $(git pull | grep -q -v 'Already up-to-date.') ]]; then
    make all && sudo make install
    # copy the examples/session file to /usr/share/wayland-sessions
    echo "Adding wayland-session"
    sudo mkdir -p /usr/share/wayland-sessions
    sudo cp example/hyprland.desktop /usr/share/wayland-sessions
    echo "Updating plugins"
    cd $HOME/.config/hypr/plugins/update.sh
else
    echo "HYPRLAND is already latest version."
fi
