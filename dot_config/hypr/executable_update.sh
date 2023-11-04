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
fi

cd $HOME/.config/hypr/hyprland-repo
# if git pull has changes then build and install
git pull
latest_hyprland_version=$(git rev-parse HEAD)
current_hyprland_version=$(hyprctl version -j | jq -r '.commit')
# Disallow upgrading if already upgraded in this session
if [[ "$latest_hyprland_version" != "$current_hyprland_version" ]] && [[ ! -f /tmp/hypr/hyprland_already_upgraded ]]; then
    make all && sudo make install
    # copy the examples/session file to /usr/share/wayland-sessions
    echo "Adding wayland-session"
    sudo mkdir -p /usr/share/wayland-sessions
    sudo cp example/hyprland.desktop /usr/share/wayland-sessions
    echo "Updating plugins"
    $HOME/.config/hypr/plugins/update.sh
    echo "Please logout and log back in to use the latest version of HYPRLAND."
    touch /tmp/hypr/hyprland_already_upgraded
else
    if [[ -f /tmp/hypr/hyprland_already_upgraded ]]; then
        echo "HYPRLAND has already been upgraded in this session, restart to receive further updates."
    else
        echo "HYPRLAND is already latest version."
    fi
fi
