#!/bin/bash
ln -s ~/.zsh/zshrc ~/.zshrc
ln -s ~/.zsh/zshenv ~/.zshenv
source ~/.zshenv

if [ "$EUID" -eq 0 ]; then
  echo "Running as root"
  alias sudo=''
fi

# check if --headless is passed
if [ "$1" == "--headless" ]; then
  echo "Headless mode"
  headless=true
fi

get_latest_release() {
# find the computer architecture
  arch=$(uname -m)
  case $arch in
      x86_64)
          arch="amd64"
          ;;
      armv6l)
          arch="arm6l"
          ;;
      armv7l)
          arch="arm7l"
          ;;
      aarch64)
          arch="arm64"
          ;;
      *)
          echo "Unknown architecture: $arch"
          exit 1
          ;;
  esac
    curl -s https://api.github.com/repos/$1/releases/latest \
    | grep "browser_download_url.*deb" \
    | grep $arch \
    | grep -v "musl" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi -
}

if command -v apt; then
    sudo apt update
    sudo apt install -y $(cat ./requirements/debPackages.txt)
    get_latest_release "Peltoche/lsd"
    sudo dpkg -i lsd*
    rm lsd*
    echo "Installing extra figlet fonts"
    git clone https://github.com/xero/figlet-fonts
    sudo mv figlet-fonts/* /usr/share/figlet/
    rm -rf figlet-fonts
    echo "Installing thefuck"
    pip3 install thefuck 
    if [ "$headless" != true ]; then
        echo "Installing notify-send"
        pip3 install notify-send
    fi
elif command -v paru &> /dev/null; then
    echo "Installing arch packages using paru"
    paru -S --noconfirm --needed $(cat ./requirements/archPackages.txt)
    echo "Installed arch packages using paru"
    if [ "$headless" != true ]; then
        echo "Installing notify-send"
        pip3 install notify-send
    fi
elif command -v pacman &> /dev/null; then
    echo "Installing arch packages using pacman"
    sudo pacman -S --noconfirm --needed $(cat ./requirements/archPackages.txt)
    echo "Installed arch packages using pacman"
    if [ "$headless" != true ]; then
        echo "Installing notify-send"
        pip3 install notify-send
    fi
    echo "As the package lsd, figlet-fonts-extra and lolcat are not available in the arch repos, you will have to install them manually"
fi

# check if the binary file exists .local/bin/zoxide
if [ ! -f ~/.local/bin/zoxide ]; then
  echo "Installing zoxide"
  curl -sS https://webinstall.dev/zoxide | bash
  installing=true
fi

export zi_home="$ZSH/.zi"
# check if the .zi directory exists
if [ ! -d "$zi_home/bin" ]; then
    echo "Installing zi in ${zi_home}/bin"
    mkdir -p "$zi_home/bin"
    git clone https://github.com/z-shell/zi.git "${zi_home}/bin"
    source ~/.zshrc
    zi self-update
    installing=true
fi

# check if installing is true
if [ "$installing" == true ]; then
  echo "Reloading shell"
  exec zsh
fi

git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"