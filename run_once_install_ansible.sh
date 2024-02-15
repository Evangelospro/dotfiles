#!/bin/bash

install_on_fedora() {
    sudo dnf install -y ansible
}

install_on_ubuntu() {
    sudo apt-get update
    sudo apt-get install -y ansible
}

install_on_mac() {
    brew install ansible
}

install_on_arch() {
    sudo pacman -Sy ansible
}

echo "Ansible not found. Installing Ansible..."
OS="$(uname -s)"
case "${OS}" in
Linux*)
    if [ -f /etc/fedora-release ]; then
        install_on_fedora
    elif grep -q "Ubuntu" /etc/os-release; then
        install_on_ubuntu
    elif grep -q "Arch" /etc/os-release; then
        install_on_arch
    else
        echo "Unsupported Linux distribution"
        exit 1
    fi
    ;;
Darwin*)
    install_on_mac
    ;;
*)
    echo "Unsupported operating system: ${OS}"
    exit 1
    ;;
esac

ansible-playbook ~/.local/share/chezmoi/bootstrap/setup.yml --ask-become-pass

echo "Ansible installation complete."
