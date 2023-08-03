FROM greyltc/archlinux-aur:paru

# Update pacman
RUN pacman-key --init
RUN pacman-key --populate

# Chaotic-AUR
RUN pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
RUN pacman-key --lsign-key 3056513887B78AEB
RUN pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm
RUN echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf

# Set timezone and locale
RUN ln -sf /usr/share/zoneinfo/Europe/Athens /etc/localtime
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen

# Install necessary packages
RUN paru -Syu git github-cli go archiso pacman-contrib binutils make gcc pkg-config fakeroot sudo zip base-devel rustup --needed --noconfirm

# Create a builder user so makepkg doesn't run as root
RUN useradd builder -ms /bin/bash -G wheel
# Allow the builder user to run sudo without a password
RUN echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# Become the builder
USER builder
WORKDIR /home/builder

# Set up Rust
RUN rustup install stable
RUN rustup default stable

COPY --chown=builder:builder ./iso /home/builder/iso

ENTRYPOINT ["/home/builder/iso/build.sh"]