autoload -Uz compinit
zcompdump_file="$XDG_CACHE_HOME/zsh/.zcompdump-$ZSH_VERSION"

# Check if zcompdump file exists and if it is older than a day
if [ ! -s "$zcompdump_file" ] || [ "$(date +'%j')" != "$(date -d "@$(/usr/bin/stat -c '%Y' "$zcompdump_file")" '+%j')" ]; then
    compinit -u -i -d "$zcompdump_file"
else
    compinit -C -d "$zcompdump_file"
fi

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

autoload -U +X bashcompinit && bashcompinit # needed for pipx to load

zinit cdreplay -q

# end profiler check that it is not already running
if [[ "${SHELL_PROFILE}" == 1 ]]; then
    zprof
    echo "Stopping profiler"
    exit
fi
