#!/bin/zsh
PYTHON_VERSION=$(python -V | cut -d " " -f 2 | cut -d "." -f 1,2)
chezmoi init --apply Evangelospro -R
cp $HOME/.config/hypr/monitors_extend.conf $HOME/.config/hypr/monitors.conf
sudo cp $HOME/.local/share/chezmoi/confs/etc/* /etc -r
sudo cp $HOME/.local/share/chezmoi/confs/opt/* /opt -r
# create default directories Desktop, Documents, Downloads, Music, Pictures, Public, Templates, Videos
mkdir -p $HOME/{Desktop,Documents,Downloads,Music,Pictures,Public,Templates,Videos}
vsCodeWorkbench=/opt/visual-studio-code/resources/app/out/vs/code/electron-sandbox/workbench
sudo cp -r $HOME/.local/share/chezmoi/dot_local/private_share/icons/vscode $vsCodeWorkbench
sudo cp $HOME/.local/share/chezmoi/confs/vscode.css $vsCodeWorkbench/vsc.css
sudo rm /usr/lib/python$PYTHON_VERSION/EXTERNALLY-MANAGED
pip install -r $HOME/.local/share/chezmoi/requirements.txt
sudo rm /usr/lib/python$PYTHON_VERSION/EXTERNALLY-MANAGED
pip install -r $HOME/.local/share/chezmoi/requirements.txt
sudo pacman-key --init
sudo pacman-key --populate
rate-mirrors --allow-root arch | sudo tee /etc/pacman.d/mirrorlist
# paru -Syyu
# cd /home/evangelospro/.local/share/chezmoi/confs/grub-themes/CyberRe && sudo ./install.sh
# Add a "#" to start of the line that has "hyprload.sh" in it in $HOME/.config/hypr/startup.conf
bash $HOME/.config/hypr/plugins/update.sh
xhost +
sudo systemctl enable --now sddm