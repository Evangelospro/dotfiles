# COMPLETIONS
_comp_options+=(globdots)

# zinit command completion
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zicompinit
zicdreplay -q # cache completions for faster startup

smartcache eval zoxide init zsh

# end profiler check that it is not already running
if [[ "${SHELL_PROFILE}" == 1 ]]; then
    zprof
    echo "Stopping profiler"
    exit
fi
