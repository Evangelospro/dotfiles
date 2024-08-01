#!/usr/bin/env bash

if ! pacman -Qs chezmoi >/dev/null 2>&1; then
    pacman -S --noconfirm chezmoi
fi

chezmoi init && chezmoi apply

rm -rf ~/.rebos-base
rebos setup
rebos gen commit "Install sync"
rebos gen current build
rebos gen tidy-up
