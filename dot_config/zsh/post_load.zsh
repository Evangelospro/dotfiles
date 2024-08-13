# COMPLETIONS
# _comp_options+=(globdots)

zcompdump_file="$XDG_CACHE_HOME/zsh/.zcompdump-$ZSH_VERSION"
# autoload -Uz compinit
# Check if zcompdump file exists and if it is older than a day
# if [ ! -s "$zcompdump_file" ] || [ "$(date +'%j')" != "$(date -d "@$(/usr/bin/stat -c '%Y' "$zcompdump_file")" '+%j')" ]; then
#     compinit -u -i -d "$zcompdump_file"
# else
#     compinit -C -d "$zcompdump_file"
# fi

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

## FZF tab completion
# export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude .git || git ls-tree -r --name-only HEAD || rg --files --hidden --follow --glob '!.git' || find ."
# export FZF_DEFAULT_OPTS=''
# zinit ice wait lucid nocd blockf depth"1"
# zinit light Aloxaf/fzf-tab

# end profiler check that it is not already running
if [[ "${SHELL_PROFILE}" == 1 ]]; then
    zprof
    echo "Stopping profiler"
    exit
fi
