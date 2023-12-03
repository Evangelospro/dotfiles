# HACKING TOOLS
## web
### check if /opt/sqlmap-bin/sqlmap.py exists
if [ -f /opt/sqlmap-bin/sqlmap.py ]; then
    alias sqlmap="/opt/sqlmap-bin/sqlmap.py"
fi
alias wpscan='wpscan -e ap,t,u --plugins-detection aggressive'
alias jwt-tool="python3 $HACKING_TOOLS/Web/jwt_tool/jwt_tool.py"
alias autorecon="autorecon --only-scans-dir --single-target"
alias webserver='updog -p 8000'
## Listeners
alias villain="python3 $HACKING_TOOLS/Villain/Villain.py"
alias shellz="bash $HACKING_TOOLS/shells/shells.sh"
alias penelope="penelope --configfile $HOME/.config/penelope/penelope.conf"
## Active Directory
alias cme='crackmapexec'
## PWN
alias pwnsetup="python3 $HACKING_TOOLS/pwn/pwnenv/pwnsetup/pwnsetup.py"
alias gdb="gdb -n -x $XDG_CONFIG_HOME/gdb/init"
alias pwndbg='gdb -q -ex init-pwndbg "$@"'
alias peda='gdb -q -ex init-peda "$@"'
alias gef='gdb -q -ex init-gef "$@"'
alias pwncompile="gcc -fno-stack-protector -z execstack -no-pie"
## Stego
alias stego-toolkit='docker run -it --rm -v $(pwd)/data:/data dominicbreuker/stego-toolkit /bin/bash'
## Networking
alias pcapng-to-pcap="$HackingSetupScripts/pcapng-to-pcap"
## General
alias rot13='tr '\''A-Za-z'\'' '\''N-ZA-Mn-za-m'\'
alias rot47='tr '\''\!-~'\'' '\''P-~\!-O'\'
alias cerbrutus="python3 ~/.local/bin/cerbrutus/cerbrutus.py"
