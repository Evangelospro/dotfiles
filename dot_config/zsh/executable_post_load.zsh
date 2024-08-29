# COMPLETIONS
_comp_options+=(globdots)

# zinit command completion
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zicompinit
zicdreplay -q # cache completions for faster startup

## FZF tab completion
export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude .git || git ls-tree -r --name-only HEAD || rg --files --hidden --follow --glob '!.git' || find ."
export FZF_DEFAULT_OPTS='-i'
# zinit ice wait lucid nocd blockf depth"1"
# zinit light Aloxaf/fzf-tab

# end profiler check that it is not already running
if [[ "${SHELL_PROFILE}" == 1 ]]; then
    zprof
    echo "Stopping profiler"
    exit
fi
