bindkey -e
# CTRL + A
bindkey '^[[s' beginning-of-line
# CTRL + E
bindkey '^[[e' end-of-line
# ALT + Delete
bindkey '^[[3~' delete-char
# ALT + Backspace
bindkey '^[[3;3~' kill-word
# CTRL + LEFT ARROW -> Move to the previous word
bindkey '^[[1;5D' backward-word
# CTRL + RIGHT ARROW -> Move to the next word
bindkey '^[[1;5C' forward-word

# bind ctrl + t to fzf fuzzy finder
bindkey '^t' fzf-file-widget

source "$ZDOTDIR/binds/fzf-binds.zsh"

# use ctrl-n for navi cheatsheets
[[ $TERM_PROGRAM != "WarpTerminal" ]] && bindkey '^n' navi_widget

# re-register the up arrow to previous command just use ctrl + R when the fancy gui is needed
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# use ctrl + r for history search
[[ $TERM_PROGRAM != "WarpTerminal" ]] && bindkey '^r' _atuin_up_search_widget
