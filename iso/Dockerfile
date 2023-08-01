FROM archlinux:latest

# Update pacman
RUN pacman-key --init
RUN pacman-key --populate

# Enable multilib
RUN echo "[multilib]" >> /etc/pacman.conf
RUN echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

# Chaotic-AUR
RUN pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
RUN pacman-key --lsign-key 3056513887B78AEB
RUN pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm
RUN echo "[chaotic-aur]" >> /etc/pacman.conf
RUN echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf

# Set timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Athens /etc/localtime

# Set locale
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen

# Set BUILD_DATE
RUN export BUILD_DATE=$(date +'%d-%m-%Y')

# Make sure container is up-to-date
RUN pacman -Syu --noconfirm

# Install necessary packages
RUN pacman -S git github-cli go archiso pacman-contrib binutils make gcc pkg-config fakeroot sudo zip base-devel rustup --needed --noconfirm

# Check free space
RUN df -h

# Create a builder user so makepkg doesn't run as root
RUN sudo useradd builder -m
# Allow the builder user to run sudo without a password
RUN echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# Become the builder
USER builder
WORKDIR /home/builder

# Set up rust
RUN rustup install stable
RUN rustup default stable

# Paru (AUR helper)
RUN git clone https://aur.archlinux.org/paru.git
RUN cd paru
RUN makepkg -si --noconfirm
RUN cd ..

RUN paru -Sy rate-mirrors-bin --noconfirm

# Find fastest mirrors
RUN rate-mirrors --allow-root arch | sudo tee /etc/pacman.d/mirrorlist; paru -Syyu  --noconfirm

# Clone ISO repo and enter it
RUN mkdir build
RUN cd build
RUN git init
RUN git remote add -f origin https://github.com/evangelospro/dotfiles
RUN git config core.sparseCheckout true
RUN echo "iso" >> .git/info/sparse-checkout
RUN git config --global init.defaultBranch main
RUN git pull origin main
RUN ls -lasih
RUN cd iso
RUN ls -lasih . # check if iso folder is there

# Build ISO and rename to match BUILD_DATE
RUN bash aur.sh enable
RUN bash build-no-cache.sh

USER root

RUN cd isoOUT
RUN ISO_PATH=$(find . -type f -name "*.iso")
RUN ISO_NAME=$(basename $ISO_PATH)
RUN ISO_PKGS=$(find . -type f -name "*.txt")

# split the iso if larger than 2GB
RUN split -b 1950M $ISO_PATH "${ISO_NAME%.*}.part"
RUN \ls -lasih .
RUN for part in $(\ls *.part*); do sha256sum $part > "${part}.sha256"; done
RUN \ls -lasih .

