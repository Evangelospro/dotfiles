# Cleanups
alias clean-cache="/usr/bin/rm -rf $HOME/.cache/* && _evalcache_clear" # shows no mercy but it is cache right?
alias clean-vscode-cache="/usr/bin/rm -rf $HOME/.config/Code*/Cache/* && /usr/bin/rm -rf $HOME/.config/Code*/CachedData/*"
alias clean-docker='docker system prune -af --volumes --filter="label!=DO_NOT_PRUNE=true"'
alias clean-packages='sudo pacman -Rns $(pacman -Qtdq) && sudo /usr/bin/rm -rf /var/cache/pacman/pkg/*'
alias clean-font-cache="fc-cache -f -v"
alias clean-seafile-cache="/usr/bin/rm -rf $HOME/.seadrive/data/file-cache"
alias clear-trash="/usr/bin/rm -rf $HOME/.local/share/Trash/*"
alias clean-dns="sudo /usr/bin/systemctl restart systemd-resolved"
