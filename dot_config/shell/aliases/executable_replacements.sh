# Command replacemnts and GNU utils
alias frm="/usr/bin/rm -rf"
alias rmz="/usr/bin/rm *.zip"
alias mkdir="mkdir -p"
alias fetch="clear && fastfetch"
alias less="less -r"
alias nc='ncat -v'
alias locate='plocate'
alias dig='doggo'
alias termbin='ncat termbin.com 9999|copy && paste'
alias which-command='whence'
alias hexdump='od -A x -t x1z -v'
alias o='xdg-open'
alias md='glow'
alias wget="wget -c --hsts-file=$HOME/.cache/wget-hsts"
alias update-timezone='sudo tzupdate'
alias perms="stat --format '%a'"
alias ffmpeg="ffpb"
alias adb="HOME=$XDG_DATA_HOME/android adb"
alias nvidia-settings='nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings'
alias svn="svn --config-dir $XDG_CONFIG_HOME/subversion"
alias xxd="hexxy --upper -td"
alias rg="batgrep"
alias format="prettybat"

alias snyk="~/.local/share/snyk-ls/snyk-linux"
