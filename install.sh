#!/usr/bin/env bash

if ! pacman -Qs chezmoi >/dev/null 2>&1; then
    sudo pacman -S --noconfirm chezmoi
fi

chezmoi init && chezmoi apply

if ! pacman -Qs rebos >/dev/null 2>&1; then
    sudo pacman -S --noconfirm rebos
fi
rm -rf ~/.rebos-base
rebos setup
rebos gen commit "Install sync"
rebos gen current build
rebos gen tidy-up
