FROM greyltc/archlinux-aur:paru

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

# Create a builder user so makepkg doesn't run as root
RUN sudo useradd builder -m
# Allow the builder user to run sudo without a password
RUN echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# Become the builder
USER builder
WORKDIR /home/builder
RUN chmod 777 -R /home/builder

# Set up rust
RUN rustup install stable
RUN rustup default stable

RUN paru -Sy rate-mirrors-bin --noconfirm

# Find fastest mirrors
RUN rate-mirrors --allow-root arch | sudo tee /etc/pacman.d/mirrorlist; paru -Syyu  --noconfirm

# Clone ISO repo and enter it
WORKDIR build
RUN git config --global init.defaultBranch main
RUN git init
RUN git remote add -f origin https://github.com/evangelospro/dotfiles
RUN git config core.sparseCheckout true
RUN echo "iso" >> .git/info/sparse-checkout
RUN git pull origin main
WORKDIR iso
RUN ls -lasih .

ENTRYPOINT ["/home/builder/build/iso/build.sh"]