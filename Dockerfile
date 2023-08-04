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
RUN paru -Syu git go archiso pacman-contrib binutils make gcc pkg-config fakeroot sudo zip base-devel rustup --needed --noconfirm

# Set up Rust
RUN rustup install stable
RUN rustup default stable
RUN ls -lah /root/.cargo/

# replace "exit $E_ROOT" with "#exit $E_ROOT" in /usr/bin/makepkg
RUN sed -i 's/exit $E_ROOT/#exit $E_ROOT/g' /usr/bin/makepkg

COPY ./iso /root/iso

ENTRYPOINT ["/root/iso/build.sh"]