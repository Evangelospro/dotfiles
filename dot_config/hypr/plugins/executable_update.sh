#!/bin/bash
# cd $HOME/.config/hypr/hyprland-repo
# git pull
cd ~/.config/hypr/plugins/split-monitor-workspaces
git pull
export export HYPRLAND_HEADERS="$HOME/.config/hypr/hyprland-repo"
make all
