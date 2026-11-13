# History lives in atuin only: no HISTFILE, nothing saved to disk by zsh
unset HISTFILE
export SAVEHIST=0
export HISTSIZE=50000

# History command configuration
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_find_no_dups      # history search shows all matches without displaying duplicates
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
