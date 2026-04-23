# ZSH autocomplete
bindkey '^I' insert-unambiguous-or-complete
bindkey -M menuselect '^I' menu-complete
bindkey -M menuselect '^M' .accept-line
## Allow for normal editing keys in the select menu
bindkey -M menuselect '^[[D' .backward-char '^[OD' .backward-char
bindkey -M menuselect '^[[C' .forward-char '^[OC' .forward-char

# bind ctrl + f to fzf
zle -N zi
bindkey '^f' zi

# up arrow and ctrl+r reverse search
bindkey '^[[A' atuin-up-search
bindkey '^R' atuin-search

bindkey '^n' navi_widget
