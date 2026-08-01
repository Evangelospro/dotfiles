source-all "$XDG_CONFIG_HOME/shell/aliases"

# Copy / Paste
alias copydir='pwd | copy'

alias please='sudo $(fc -ln -1)'
alias pls='please'

# Grub
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# Always need sudo, don't even bother
alias shutdown="systemctl poweroff"
alias reboot="systemctl reboot"
alias umount="sudo umount"
alias mount="sudo mount"

# kdeconnect
alias share="gapplication launch ca.andyholmes.Valent $@"

# alias chmod commands
alias mx='chmod a+x'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Hashing
alias sha1='openssl sha1'
