# ZSH autocomplete
bindkey '^I' menu-select
bindkey "$terminfo[kcbt]" menu-select
bindkey -M menuselect '^I' menu-complete
bindkey -M menuselect '^M' .accept-line

# bind ctrl + f to fzf
zle -N zi
bindkey '^f' zi

# up arrow and ctrl+r reverse search
bindkey '^[[A' atuin-up-search
bindkey '^R' atuin-search

bindkey '^n' navi_widget
