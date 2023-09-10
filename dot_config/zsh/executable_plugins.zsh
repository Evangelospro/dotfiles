[ ! -d $ZINIT[HOME_DIR] ] && mkdir -p "$(dirname $ZINIT[HOME_DIR])"
[ ! -d $ZINIT[HOME_DIR]/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT[HOME_DIR]"

# Loading ZINIT
source "$ZINIT[HOME_DIR]/zinit.zsh"

zinit ice as'null' from"gh-r" sbin
zinit light ajeetdsouza/zoxide
zinit has'zoxide' wait lucid for \
z-shell/zsh-zoxide

## Plugins
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1"
zinit ice id-as="autosuggestions"; zinit light zsh-users/zsh-autosuggestions

# Completions
zinit ice wait lucid blockf id-as="zsh-completions"
zinit light zsh-users/zsh-completions

zinit snippet PZT::modules/completion
zstyle ':completion:*' completer _complete _match _expand

zinit wait lucid light-mode depth=1 for \
pick="autopair.zsh" atload="autopair-init" hlissner/zsh-autopair \
pick="async.zsh" mafredri/zsh-async

zinit ice wait lucid as"program" pick"bin/fzf"
zinit snippet OMZP::fzf

# history
zinit ice wait
zinit snippet OMZP::dirhistory

zinit ice wait 2
zinit light zdharma-continuum/history-search-multi-word

zinit ice wait 2
zinit snippet $ZSH/scripts/utils/web-search.zsh

# bitwarden auto export session
zinit ice wait
zinit light Game4Move78/zsh-bitwarden

# zinit ice wait
# zinit light tom-auger/cmdtime

zinit ice wait
zinit light jgogstad/passwordless-history

zinit ice wait
zinit light MichaelAquilina/zsh-you-should-use

export YSU_IGNORED_ALIASES=(".." "l" "s" "ls" "ll" "cd.." "pdw" "sudo" "fd" "locate")
export YSU_HARDCORE=1

# check that you are not in docker or a server avoid in headless installs
if [ -z "$DISPLAY" ] && [ -z "$SSH_CLIENT" ]; then
    echo "Not in a gui server"
else
    zinit ice wait 2
    zinit light MichaelAquilina/zsh-auto-notify
fi

## History search
# ctrl-r
zinit light-mode for \
z-shell/H-S-MW \
zsh-users/zsh-history-substring-search

# ZINIT plugin for diff-so-fancy https://github.com/z-shell/zsh-diff-so-fancy
zinit ice wait lucid as'program' pick'bin/git-dsf'
zinit load z-shell/zsh-diff-so-fancy

# Theming

# Using normal load works
zinit depth=1 lucid nocd for \
romkatv/powerlevel10k

# Syntax highlight must be the last one
# import dracula theme
source "$ZSH/themes/dracula-theme.zsh"
zinit light zdharma-continuum/fast-syntax-highlighting

# Search repos for programs that can't be found
source /usr/share/doc/pkgfile/command-not-found.zsh 2>/dev/null
