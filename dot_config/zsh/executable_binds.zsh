source "$ZDOTDIR/binds/fzf-binds.zsh"

# bindkey -e

# ZSH autocomplete
bindkey              '^I'         menu-complete
bindkey -M menuselect  '^[[D' .backward-char  '^[OD' .backward-char
bindkey -M menuselect  '^[[C'  .forward-char  '^[OC'  .forward-char
bindkey -M menuselect '^M' .accept-line

# ZSH autosuggestions
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# CTRL + A
bindkey '^[[s' beginning-of-line
# CTRL + E
bindkey '^[[e' end-of-line

# delete key
bindkey '^[[3~' delete-char
# backspace key
bindkey '^?' backward-delete-char

# Ctrl+Delete: kill the word forward
bindkey '^[[3;5~' kill-word
# Ctrl+Backspace: kill the word backward
bindkey "^H" backward-kill-word

# CTRL + LEFT ARROW -> Move to the previous word
bindkey '^[[1;5D' backward-word
# CTRL + RIGHT ARROW -> Move to the next word
bindkey '^[[1;5C' forward-word

# bind ctrl + t to fzf fuzzy finder
# bindkey '^t' fzf-file-widget


# use ctrl-n for navi cheatsheets
[[ $TERM_PROGRAM != "WarpTerminal" ]] && bindkey '^n' navi_widget

bindkey '^R' atuin-search

# bind to the up key, which depends on terminal mode
# bindkey '^[[A' atuin-up-search
# bindkey '^[OA' atuin-up-search

# shift + tab - suggest
bindkey '^[[Z' zsh_gh_copilot_suggest
# ctrl + / - explain
bindkey '^_' zsh_gh_copilot_explain
