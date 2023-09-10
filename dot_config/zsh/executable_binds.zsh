bindkey '^[[s' beginning-of-line
bindkey '^[[e' end-of-line
bindkey '^[[3~' delete-char

# bind ctrl + t to fzf fuzzy finder
bindkey '^t' fzf-file-widget

source "$ZSH/binds/fzf-binds.zsh"
