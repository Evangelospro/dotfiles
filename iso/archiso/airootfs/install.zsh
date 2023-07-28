#!/bin/zsh
# Ensure connection to the internet and time synchronization
if ! ping -c 1 archlinux.org &> /dev/null; then
    echo "No internet connection please activate a connection or connect to an ethernet cable"
    nmtui
fi
timedatectl set-ntp true
chsh -s /usr/bin/zsh
PYTHON_VERSION=$(python -V | cut -d " " -f 2 | cut -d "." -f 1,2)
chezmoi init --apply Evangelospro -R
cp $HOME/.config/hypr/monitors_extend.conf $HOME/.config/hypr/monitors.conf
# /var/log/Calamares-install.json if exists then we are past the installation phase
if [[! -f /var/log/Calamares-install.json ]]; then
    echo "Installation phase"
    sudo cp $HOME/.local/share/chezmoi/confs/etc/* /etc/ -r
    sudo cp $HOME/.local/share/chezmoi/confs/opt/* /opt/ -r
    sudo pacman-key --init
    sudo pacman-key --populate
    rate-mirrors --allow-root arch | sudo tee /etc/pacman.d/mirrorlist
    function update(){
        paru -Syu --noconfirm
        git pull $HOME/.config/hypr/hyprland-repo && $HOME/.config/hypr/plugins/update.sh
        zi self-update
        zi update
        navi-update
    }
    update
    sudo rm /usr/lib/python$PYTHON_VERSION/EXTERNALLY-MANAGED
    sudo systemctl enable --now sddm
else
    echo "Post installation phase"
    rm /var/log/Calamares* # stores critical information (even passwords)
    # create default directories Desktop, Documents, Downloads, Music, Pictures, Public, Templates, Videos
    mkdir -p $HOME/{Desktop,Documents,Downloads,Music,Pictures,Public,Templates,Videos}
    vsCodeWorkbench=/opt/visual-studio-code/resources/app/out/vs/code/electron-sandbox/workbench
    sudo cp -r $HOME/.local/share/chezmoi/dot_local/private_share/icons/vscode $vsCodeWorkbench
    sudo cp $HOME/.local/share/chezmoi/confs/vscode.css $vsCodeWorkbench/vsc.css# paru -Syyu
    pip install -r $HOME/.local/share/chezmoi/requirements.txt
    rustup default stable
    # Lolcate database
    lolcate --create
    lolcate --update 2>/dev/null
    # cd /home/evangelospro/.local/share/chezmoi/confs/grub-themes/CyberRe && sudo ./install.sh
    sudo rm /usr/lib/python$PYTHON_VERSION/EXTERNALLY-MANAGED
fi