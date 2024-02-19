#!/usr/bin/env bash

# Install git, paru, chezmoi and rebos
if ! pacman -Qs git >/dev/null 2>&1; then
    sudo pacman -Sy --noconfirm git
fi

if ! pacman -Qs paru >/dev/null 2>&1; then
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd ..
    rm -rf paru
fi

if ! pacman -Qs chezmoi >/dev/null 2>&1; then
    paru -S --noconfirm chezmoi
fi

chezmoi init --apply Evangelospro

if ! pacman -Qs rebos >/dev/null 2>&1; then
    # use ~/.local/share/chezmoi/confs/etc/pacman.conf
    paru -S --noconfirm rebos --config ~/.local/share/chezmoi/confs/etc/pacman.conf
fi
