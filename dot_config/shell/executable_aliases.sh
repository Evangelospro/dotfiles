source $XDG_CONFIG_HOME/shell/aliases/hacking.zsh

# Dotfiles
alias config="chezmoi cd && $VISUAL ."
alias zshconfig="$VISUAL $ZDOTDIR"

alias please='sudo $(fc -ln -1)'
alias pls='please'

# Grub
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# windows managers
alias restart-gnome="killall -3 gnome-shell"
alias restart-kde="killall -3 plasmashell"

# Copy / Paste (X11 / Wayland) remove ending newline when copying
alias copy="if [[ -z $WAYLAND_DISPLAY ]]; then tr -d '\n' | xclip -selection clipboard; else wl-copy; fi"
alias paste="if [[ -z $WAYLAND_DISPLAY ]]; then xclip -selection clipboard -o; else wl-paste; fi"
alias copydir='pwd | copy && paste'

# Listing
# alias tree='tree -a -I .git --dirsfirst'
# alias ls='lsd -hAFlt --group-dirs first --color=always'
# alias l='lsd -hAFlt --group-dirs first --color=always'
# alias lst='lsd -hAFlt --tree --group-dirs first --color=always'
# alias tree='lsd -hAFlt --tree --group-dirs first --color=always'

# Servers /  SSH
# alias ssh='wezterm ssh'

# Command replacemnts and GNU utils
alias frm="/usr/bin/rm -rf"
alias rmz="/usr/bin/rm *.zip"
alias mkdir="mkdir -p"
alias fetch="clear && fastfetch"
alias less="less -r"
alias cp="fcp"
alias nc='ncat -v'
alias locate='plocate'
alias dig='doggo'
alias termbin='\ncat termbin.com 9999|copy && paste'
alias which-command='whence'
alias hexdump='od -A x -t x1z -v'
alias o='handlr open'
alias md='glow'
alias wget="wget -c --hsts-file=$HOME/.cache/wget-hsts"
alias update-timezone='sudo tzupdate'
alias perms="stat --format '%a'"
alias adb='HOME="$XDG_DATA_HOME"/android adb'
alias nvidia-settings='nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings'
alias yarn="yarn --use-yarnrc $XDG_CONFIG_HOME/yarn/config"
alias svn="svn --config-dir $XDG_CONFIG_HOME/subversion"

# GIT
alias g='git'
alias ga='git add'
alias gcam='git commit -a -m'
alias git-update-recursively="find . -name .git -type d -print -prune -exec git --git-dir '{}' fetch --all ';'"

# ZSH
alias reload='exec zsh -l'
alias tobash='sudo chsh evangelospro -s /bin/bash && echo '\''Now log out.'\'
alias tozsh='sudo chsh evangelospro -s /bin/zsh && echo '\''Now log out.'\'

# python / pip / pipx
alias p='ipython' #'python3'
alias pip='noglob pip'
alias pipx='noglob pipx'
alias pipi='pip install'
alias pipir='pip install -r'
alias pipreq='pip freeze > requirements.txt'
alias pipua='pip list | cut -d " " -f1 | tail +3 | xargs pip install -U'

# PS
alias psa='ps auxf'
alias pscpu='ps auxf | sort -nr -k 3'
alias psgrep='ps aux | grep -v grep | grep -i -e VSZ -e'
alias psmem='ps auxf | sort -nr -k 4'

# Always need sudo, don't even bother
alias shutdown="sudo shutdown"
alias reboot="sudo reboot"
alias umount="sudo umount"
alias mount="sudo mount"

# kdeconnect
if type kdeconnect-cli &>/dev/null; then
    # don't echo anything
    current_device=$(kdeconnect-cli -a --id-name-only 2>/dev/null | cut -d ' ' -f 1)
    alias share-clip="kdeconnect-cli -d $current_device --share-text $@"
    alias share="kdeconnect-cli -d $current_device --share $@"
fi

# get fastest mirrors
alias ram='rate-mirrors --allow-root arch | sudo tee /etc/pacman.d/mirrorlist; paru -Syyu'

# Networking
alias ip='ip -color -brief'
alias wmonitor-off='sudo airmon-ng stop wlp4s0f3u3'
alias wmonitor-on='sudo airmon-ng start wlp4s0f3u3'

# Disables / Enables
alias enable-ping='sudo sysctl -w net.ipv4.icmp_echo_ignore_all=0'
alias disable-ping='sudo sysctl -w net.ipv4.icmp_echo_ignore_all=1'
alias disable-ipv6='sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1'
alias enable-ipv6='sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0'
alias disable-aslr='sudo sysctl -w kernel.randomize_va_space=0'
alias enable-aslr='sudo sysctl -w kernel.randomize_va_space=2'

# Cleanups
alias clean-cache="sudo /usr/bin/rm -rf $HOME/.cache/* && _evalcache_clear" # shows no mercy but it is cache right?
alias clean-docker='docker system prune -f --volumes'
alias clean-packages='sudo pacman -Rns $(pacman -Qtdq) && sudo /usr/bin/rm -rf /var/cache/pacman/pkg/*'
alias clean-font-cache="fc-cache -f -v"
alias clean-seafile-cache="/usr/bin/rm -rf $HOME/.seadrive/data/file-cache"
alias clear-trash="/usr/bin/rm -rf $HOME/.local/share/Trash/*"

# basics/typos
alias ..='cd ..'
alias cd..='cd ..'
alias pdw="pwd"
alias sl='ls'
alias s='ls'
alias l='ls'
alias q='exit'
alias qq='exit'
alias sduo='sudo'

# image utils
alias icat="wezterm imgcat"
