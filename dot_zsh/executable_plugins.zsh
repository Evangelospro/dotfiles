# Using normal load works
zi depth=1 lucid nocd for \
    romkatv/powerlevel10k

# PLUGINS
zi ice wait
zi snippet OMZP::dirhistory

zi ice wait
zi snippet $ZSH/scripts/utils/web-search.zsh

zi ice wait
zi light hlissner/zsh-autopair

# bitwarden auto export session
zi ice wait
zi light Game4Move78/zsh-bitwarden

zi ice wait 
zi light tom-auger/cmdtime

zi ice wait
zi light jgogstad/passwordless-history

zi ice wait
zi light o1001100/ssh-connect

zi ice wait
zi light MichaelAquilina/zsh-you-should-use

export YSU_IGNORED_ALIASES=("ls" "ll" "cd.." "pdw")
export YSU_HARDCORE=1

# replaces zsh-you-should-use
# zi ice wait
# zi light djui/alias-tips
# export ZSH_PLUGINS_ALIAS_TIPS_EXPAND=0


# check that you are not in docker or a server avoid in headless installs
if [ -z "$DISPLAY" ] && [ -z "$SSH_CLIENT" ]; then
  echo "Not in a gui server"
else
  zi ice wait
  zi light MichaelAquilina/zsh-auto-notify
fi

# ZSH AUTOCOMPLETION
zi ice wait
zi light marlonrichert/zsh-autocomplete

# zi ice wait
# zi light tom-doerr/zsh_codex

# zi ice wait
# zi light RobSis/zsh-completion-generator

# autocompletion additions + fast-syntax-highlighting + zsh-autosuggestions
zi wait lucid for \
  atinit'ZI[COMPINIT_OPTS]=-C; zicompinit; zicdreplay' \
    zsh-users/zsh-syntax-highlighting \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

# loaf after syntax highlighting to prevent "= is not a valid identifier" error
zi ice wait
zi light arzzen/calc.plugin.zsh
