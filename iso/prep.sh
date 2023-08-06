#!/bin/bash
# Update pacman
if [ ! -f $HOME/.gnupg/pubring.kbx ]; then
	pacman-key --init
	pacman-key --populate

	# Chaotic-AUR
	pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
	pacman-key --lsign-key 3056513887B78AEB
	pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm
	echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
fi

# Set timezone and locale
ln -sf /usr/share/zoneinfo/Europe/Athens /etc/localtime
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen

# Install necessary packages
pacman -Syu git go archiso pacman-contrib binutils make gcc pkg-config fakeroot sudo zip base-devel rust cargo --needed --noconfirm
