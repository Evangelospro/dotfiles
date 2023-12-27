bindkey -e
bindkey '^[[s' beginning-of-line
bindkey '^[[e' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[3;3~' kill-word

# bind ctrl + t to fzf fuzzy finder
bindkey '^t' fzf-file-widget

source "$ZDOTDIR/binds/fzf-binds.zsh"

# use ctrl-n for navi cheatsheets
bindkey '^n' navi_widget
