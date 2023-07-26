#!/bin/bash
cd $HOME/.config/hypr/hyprland-repo
git pull --recurse-submodules
sudo make pluginenv
cd ~/.config/hypr/plugins/split-monitor-workspaces
git pull
export export HYPRLAND_HEADERS="$HOME/.config/hypr/hyprland-repo"
rm ~/.config/hypr/plugins/split-monitor-workspaces/*.so
make all
