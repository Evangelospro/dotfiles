#!/usr/bin/env bash

if ! pacman -Qs chezmoi >/dev/null 2>&1; then
    paru -S --noconfirm chezmoi
fi

chezmoi init --apply Evangelospro

rm -rf ~/.rebos-base
rebos setup
rebos gen commit "Install sync"
rebos gen current build
rebos gen tidy-up
