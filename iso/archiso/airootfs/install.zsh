#!/bin/zsh
chsh -s /usr/bin/zsh
PYTHON_VERSION=$(python -V | cut -d " " -f 2 | cut -d "." -f 1,2)
chezmoi init --apply Evangelospro -R
function update(){
    # chaotic was taking over hence hyprland is on hold
    paru -Syu
    paru -Syu aur/hyprland-git && git pull $HOME/.config/hypr/hyprland-repo && $HOME/.config/hypr/plugins/update.sh
    zi self-update
    zi update
    navi-update
}
update
cp $HOME/.config/hypr/monitors_extend.conf $HOME/.config/hypr/monitors.conf
sudo cp $HOME/.local/share/chezmoi/confs/etc/* /etc/ -r
sudo cp $HOME/.local/share/chezmoi/confs/opt/* /opt/ -r
# create default directories Desktop, Documents, Downloads, Music, Pictures, Public, Templates, Videos
mkdir -p $HOME/{Desktop,Documents,Downloads,Music,Pictures,Public,Templates,Videos}
vsCodeWorkbench=/opt/visual-studio-code/resources/app/out/vs/code/electron-sandbox/workbench
sudo cp -r $HOME/.local/share/chezmoi/dot_local/private_share/icons/vscode $vsCodeWorkbench
sudo cp $HOME/.local/share/chezmoi/confs/vscode.css $vsCodeWorkbench/vsc.css
sudo pacman-key --init
sudo pacman-key --populate
rate-mirrors --allow-root arch | sudo tee /etc/pacman.d/mirrorlist
# paru -Syyu
sudo rm /usr/lib/python$PYTHON_VERSION/EXTERNALLY-MANAGED
pip install -r $HOME/.local/share/chezmoi/requirements.txt
rustup default stable
# Lolcate database
lolcate --create
lolcate --update 2>/dev/null
# cd /home/evangelospro/.local/share/chezmoi/confs/grub-themes/CyberRe && sudo ./install.sh
# Add a "#" to start of the line that has "hyprload.sh" in it in $HOME/.config/hypr/startup.conf
bash $HOME/.config/hypr/plugins/update.sh
# xhost + aliased calamares to xhost + && calamares
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable --now sddm