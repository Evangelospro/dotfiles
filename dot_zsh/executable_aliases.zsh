# Dotfiles
alias config='chezmoi cd && code .'
alias zshconfig="code $ZSH"

# alias s='/usr/bin/python ~/.zsh/scripts/utils/prevAsSudo.py'
alias sudo='sudo '
alias please='sudo $(fc -ln -1)'

# Hacking platforms 
alias thm="~/.local/bin/thm/thm"
alias htb="~/.local/bin/htb/htb"

# HACKING TOOLS
alias villain="python3 $HACKING_TOOLS/Villain/Villain.py"
alias rustscan="rustscan --ulimit 5000 $@ -- -sC -sV"
alias stego="$HackingSetupScripts/stego/stego"
alias steganabara="~/Desktop/HACKING/HACKING-TOOLS/Stego/Steganabara/run"
alias cerbrutus="python3 ~/.local/bin/cerbrutus/cerbrutus.py"
alias autorecon="autorecon --only-scans-dir --single-target"
alias rot13='tr '\''A-Za-z'\'' '\''N-ZA-Mn-za-m'\'
alias rot47='tr '\''\!-~'\'' '\''P-~\!-O'\'
alias rr='nc evangelospro.com 1337'
alias webserver='updog -p 8000'
alias penelope="/usr/bin/python3 /usr/bin/penelope/penelope.py"
alias pwncompile="gcc -fno-stack-protector -z execstack -no-pie"
alias ctfinit="python3 ~/Desktop/HACKING/CTF\ Automation/ctfinit.py"
alias mobsf="~/SCRIPTS/r ~/Desktop/HACKING/HACKING-TOOLS/Mobile/Mobile-Security-Framework-MobSF/run.sh"
alias curl="curlie"
alias burl="curl -x localhost:8080 -k "
alias frm="/usr/bin/rm -rf"
alias rm="$ZSH/scripts/utils/rm"
alias rmz="/usr/bin/rm *.zip"
alias pcapng-to-pcap="$HackingSetupScripts/pcapng-to-pcap"
alias pwndbg='gdb -q -ex init-pwndbg "$@"'
alias hosts='sudo ~/SCRIPTS/hosts.sh'
alias chosts='echo "127.0.0.1 localhost"|sudo tee /etc/hosts'
alias navi-update="$ZSH/scripts/updaters/navi-updater.sh"
alias feroxbuster="feroxbuster -e"
alias wpscan='wpscan --plugins-detection aggressive'
alias upload="$ZSH/scripts/utils/upload"

# venvs for each venv in ~/.virtualenvs
source $ZSH/scripts/venvs/venvs.zsh

# Grub
alias grub-update='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# GNOME
alias restart-gnome="killall -3 gnome-shell"

# clipboard
# X11
# alias copy='xclip -selection clipboard'
# alias paste='xclip -selection clipboard -o'
# Wayland
alias copy='wl-copy'
alias paste='wl-paste'
alias copydir='pwd | tr -d '\n' |copy|paste'

# exa/lsd ignore on --tree
alias ls='lsd -hAFlt --group-dirs first --color=always'
alias l='lsd -hAFlt --group-dirs first --color=always'
alias lst='lsd -hAFlt --tree --group-dirs first --color=always'

# Servers
alias server='ssh -i ~/.ssh/server evangelospro@evangelospro.com'
alias proxmox='ssh -i ~/.ssh/proxmox root@192.168.10.3'
alias portainer='ssh -i ~/.ssh/portainer evangelospro@192.168.10.4'
alias scripter='ssh -i ~/.ssh/scripter evangelospro@192.168.10.5'
alias eraspberry1='ssh -i ~/.ssh/eraspberry1 evangelospro@192.168.10.6'

# Command minimization
alias reload='exec zsh -l'
alias mvd='mv ~/Downloads/"$(/usr/bin/ls -t ~/Downloads | head -n 1)" .'
alias cat='/usr/bin/bat --theme=Dracula'
alias df='df -h'
alias diff='diff --color'
alias free='free -m'
alias g=git
alias ga='git add'
alias gcam='git commit -a -m'
alias jctl='journalctl -p 3 -xb'
alias pip='noglob pip3'
alias pipir='pip3 install -r requirements.txt'
alias pipreq='pip3 freeze > requirements.txt'
alias pipua='pip3 list | cut -d " " -f1 | tail +3 | xargs pip3 install -U'
alias psa='ps auxf'
alias pscpu='ps auxf | sort -nr -k 3'
alias psgrep='ps aux | grep -v grep | grep -i -e VSZ -e'
alias psmem='ps auxf | sort -nr -k 4'
alias termbin='nc termbin.com 9999|copy'
alias tobash='sudo chsh evangelospro -s /bin/bash && echo '\''Now log out.'\'
alias tozsh='sudo chsh evangelospro -s /bin/zsh && echo '\''Now log out.'\'
alias which-command=whence
alias clear-font-cache="fc-cache -f -v"
alias wmonitor-off='sudo airmon-ng stop wlp4s0f3u3'
alias wmonitor-on='sudo airmon-ng start wlp4s0f3u3'
alias p='python3'
alias fd='fd --hidden --follow'
alias e="code"
alias q='exit'
alias hexdump='od -A x -t x1z -v'
alias ip='ip -color -brief'
alias o='xdg-open'
alias tree='tree -a -I .git --dirsfirst'
alias utc='env TZ=UTC date'
# alias clear="$ZSH/scripts/utils/clear.sh"
alias md='mdv'
alias git-update="find . -name .git -type d -print -prune -exec git --git-dir '{}' fetch --all ';'"
alias wget="wget -c"
alias timezoneUpdate='sudo tzupdate'
alias dolphin='dolphin . &'
alias perms="stat --format '%a'"
# check if headless
if [[ -z $DISPLAY ]]; then
    alias kdeconnect-cli="~/.local/share/gnome-shell/extensions/gsconnect@andyholmes.github.io/service/daemon.js"
    alias send-text="kdeconnect-cli -d $(kdeconnect-cli -a|cut -f 1) --share-text $@"
    alias send-file="kdeconnect-cli -d $(kdeconnect-cli -a|cut -f 1) --share-file $@"
    alias send-link="kdeconnect-cli -d $(kdeconnect-cli -a|cut -f 1) --share-link $@"
fi

# get fastest mirrors in your neighborhood
alias ram='rate-mirrors --allow-root arch | sudo tee /etc/pacman.d/mirrorlist; paru -Syyu'

# Networking
alias flush-cache='sudo killall -USR1 systemd-resolved'
alias enable-ping='sudo sysctl -w net.ipv4.icmp_echo_ignore_all=0'
alias disable-ping='sudo sysctl -w net.ipv4.icmp_echo_ignore_all=1'

# Package managment / cleanup
alias clean-docker='docker system prune -f'
alias clean-packages='sudo pacman -Rns $(pacman -Qtdq)'
alias paru="$ZSH/scripts/utils/paru"

# typos
alias cd..='cd ..'
alias pdw="pwd"
alias sl='ls'

# image utils
alias rotate='jpegtran -perfect -rotate'
