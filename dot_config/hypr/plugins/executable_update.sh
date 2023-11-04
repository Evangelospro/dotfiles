#!/bin/bash
export HYPRLAND_HEADERS="$HOME/.config/hypr/hyprland-repo"
cd $HYPRLAND_HEADERS
git pull --recurse-submodules # git submodule update --init --recursive must be run on the first time
cd ~/.config/hypr/plugins/split-monitor-workspaces
git pull
# if any .so files exist, delete them
if [ -f ~/.config/hypr/plugins/split-monitor-workspaces/*.so ]; then
    rm ~/.config/hypr/plugins/split-monitor-workspaces/*.so
fi
make all
