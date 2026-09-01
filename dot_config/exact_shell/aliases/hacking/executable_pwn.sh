alias pwnsetup="python3 $HACKING_TOOLS/pwn/pwnenv/pwnsetup/pwnsetup.py"
alias gdb="gdb -n -x $XDG_CONFIG_HOME/gdb/init"
alias pwndbg='gdb -q -ex init-pwndbg "$@"'
alias peda='gdb -q -ex init-peda "$@"'
alias gef='gdb -q -ex init-gef "$@"'
alias pwncompile="gcc -fno-stack-protector -z execstack -no-pie"

# Pwntools
alias cyclic="pwn cyclic $@"
alias dis="pwn disasm $@"
