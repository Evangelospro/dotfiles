#!/bin/bash
# check if the hyprland-git package exists and warn before removing it
if sudo pacman -Qi hyprland-git &> /dev/null; then
    echo "You have hyprland-git installed. It will be removed."
    echo "Press Ctrl+C to abort or in 10 seconds this script will continue."
    sleep 10
    sudo pacman -R hyprland-git
fi

# build and install the hyprland package from the local repo
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
