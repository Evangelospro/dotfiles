typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"

# ZSH autocomplete
bindkey '^I' insert-unambiguous-or-complete
bindkey -M menuselect '^I' menu-complete
bindkey -M menuselect '^M' .accept-line
## Allow for normal editing keys in the select menu
bindkey -M menuselect '^[[D' .backward-char '^[OD' .backward-char
bindkey -M menuselect '^[[C' .forward-char '^[OC' .forward-char

# delete key
bindkey -- "${key[Delete]}" delete-char
# bindkey -M menuselect "${terminfo[kdch1]}" delete-char
# backspace key
bindkey '^?' backward-delete-char
# bindkey -M menuselect '^?' backward-delete-char

# CTRL + A
bindkey '^A' beginning-of-line
bindkey -M menuselect '^A' beginning-of-line
# CTRL + E
bindkey '^E' end-of-line
bindkey -M menuselect '^E' end-of-line

# Ctrl+Delete: kill the word forward
bindkey '^[[3;5~' kill-word
bindkey -M menuselect '^[[3;5~' kill-word
# Ctrl+Backspace: kill the word backward
bindkey "^H" backward-kill-word
bindkey -M menuselect "^H" backward-kill-word

# CTRL + LEFT ARROW -> Move to the previous word
bindkey '^[[1;5D' backward-word
bindkey -M menuselect '^[[1;5D' backward-word
# CTRL + RIGHT ARROW -> Move to the next word
bindkey '^[[1;5C' forward-word
bindkey -M menuselect '^[[1;5C' forward-word

# bind ctrl + f to fzf
zle -N zi
bindkey '^f' zi

# use ctrl-n for navi cheatsheets
if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
    bindkey '^n' navi_widget
    bindkey '^R' atuin-search

    # bind to the up key, which depends on terminal mode
    # bindkey "${terminfo[kcuu1]}" atuin-up-search
    # bindkey '^[OA' atuin-up-search
fi
