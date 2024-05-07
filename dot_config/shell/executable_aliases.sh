source-all "$XDG_CONFIG_HOME/shell/aliases"

# Copy / Paste
alias copydir='pwd | copy'

alias please='sudo $(fc -ln -1)'
alias pls='please'

# Grub
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# windows managers
alias restart-gnome="killall -3 gnome-shell"
alias restart-kde="killall -3 plasmashell"

# Listing
# alias tree='tree -a -I .git --dirsfirst'
# alias ls='lsd -hAFlt --group-dirs first --color=always'
# alias l='lsd -hAFlt --group-dirs first --color=always'
# alias lst='lsd -hAFlt --tree --group-dirs first --color=always'
# alias tree='lsd -hAFlt --tree --group-dirs first --color=always'

# Always need sudo, don't even bother
alias shutdown="systemctl poweroff"
alias reboot="systemctl reboot"
alias umount="sudo umount"
alias mount="sudo mount"

# kdeconnect
alias share="gapplication launch ca.andyholmes.Valent $@"

# get fastest mirrors
alias ram='rate-mirrors --allow-root arch | sudo tee /etc/pacman.d/mirrorlist; paru -Syyu'
