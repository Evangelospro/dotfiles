# HACKING TOOLS
## Listeners
alias penelope="penelope --configfile $HOME/.config/penelope/penelope.conf"
## Active Directory
alias cme='crackmapexec'
## Stego
alias stego-toolkit='docker run -it --rm -v $(pwd)/data:/data dominicbreuker/stego-toolkit /bin/bash'
## Networking
alias pcapng-to-pcap="$HackingSetupScripts/pcapng-to-pcap"
## General
alias rot13='tr '\''A-Za-z'\'' '\''N-ZA-Mn-za-m'\'
alias rot47='tr '\''\!-~'\'' '\''P-~\!-O'\'
alias cerbrutus="python3 ~/.local/bin/cerbrutus/cerbrutus.py"
