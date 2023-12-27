# History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # Share history between different instances of the shell
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt incappendhistorytime
setopt appendhistory # Immediately append history instead of overwriting
setopt autocd        # if only directory path is entered, cd there.
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
setopt complete_in_word
setopt always_to_end

setopt INTERACTIVE_COMMENTS
