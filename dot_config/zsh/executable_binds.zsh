source "$ZDOTDIR/binds/fzf-binds.zsh"

# bindkey -e
# CTRL + A
# bindkey '^[[s' beginning-of-line
# CTRL + E
# bindkey '^[[e' end-of-line

# CTRL + Delete
# bindkey '^[[3;5~' delete-char
# CTRL + Backspace
# bindkey '^H' kill-word

# CTRL + LEFT ARROW -> Move to the previous word
bindkey '^[[1;5D' backward-word
# CTRL + RIGHT ARROW -> Move to the next word
bindkey '^[[1;5C' forward-word

# bind ctrl + t to fzf fuzzy finder
# bindkey '^t' fzf-file-widget


# use ctrl-n for navi cheatsheets
[[ $TERM_PROGRAM != "WarpTerminal" ]] && bindkey '^n' navi_widget

bindkey '^r' atuin-search

# bind to the up key, which depends on terminal mode
bindkey '^[[A' atuin-up-search
bindkey '^[OA' atuin-up-search

# shift + tab - suggest
bindkey '^[[Z' zsh_gh_copilot_suggest
# ctrl + / - explain
bindkey '^_' zsh_gh_copilot_explain
