[ ! -d $ZINIT[HOME_DIR] ] && mkdir -p "$(dirname $ZINIT[HOME_DIR])"
[ ! -d $ZINIT[HOME_DIR]/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT[HOME_DIR]"

# Loading ZINIT
source "$ZINIT[HOME_DIR]/zinit.zsh"

## Plugins
export ZSH_EVALCACHE_DISABLE=false
export ZSH_EVALCACHE_DIR="$XDG_CACHE_HOME/zsh/evalcache"
# load mroth/evalcache
# zinit ice wait
zinit load mroth/evalcache

zinit ice wait 2
zinit snippet $ZSH/scripts/utils/web-search.zsh

# bitwarden auto export session
zinit ice wait
zinit light Game4Move78/zsh-bitwarden

zinit ice wait
zinit light jgogstad/passwordless-history

export YSU_IGNORED_ALIASES=(".." "l" "s" "ls" "ll" "cd.." "pdw" "sudo" "fd" "locate")
export YSU_HARDCORE=1
zinit ice wait
zinit light MichaelAquilina/zsh-you-should-use

# check that you are not in docker or a server avoid in headless installs
if [ -z "$DISPLAY" ] && [ -z "$SSH_CLIENT" ]; then
    echo "Not in a gui server"
else
    zinit ice wait 2
    zinit light MichaelAquilina/zsh-auto-notify
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1"
zinit ice id-as="autosuggestions"; zinit light zsh-users/zsh-autosuggestions

# evaluting some useful commands and aliases
_evalcache register-python-argcomplete pipx
_evalcache thefuck --alias
_evalcache direnv hook zsh
# eval "$($ZSH/scripts/venvs/venv_finder.sh)"

# Mcfly great scot history search
export MCFLY_FUZZY=2
export MCFLY_RESULTS=25
export MCFLY_INTERFACE_VIEW=BOTTOM
export MCFLY_RESULTS_SORT=RANK
export MCFLY_PROMPT="❯"
# eval "$(mcfly init zsh)"
_evalcache mcfly init zsh

# Completions
export _ZO_CMD_PREFIX="asjdkadd" # just disable the zi alias
zinit ice as'null' from"gh-r" sbin
zinit light ajeetdsouza/zoxide
zinit has'zoxide' wait lucid for \
z-shell/zsh-zoxide

zinit ice wait lucid blockf id-as="zsh-completions"
zinit light zsh-users/zsh-completions

zinit snippet PZT::modules/completion
zstyle ':completion:*' completer _complete _match _expand

zinit wait lucid light-mode depth=1 for \
pick="autopair.zsh" atload="autopair-init" hlissner/zsh-autopair \
pick="async.zsh" mafredri/zsh-async

zinit ice wait lucid as"program" pick"bin/fzf"
zinit snippet OMZP::fzf

## FZF tab completion
zinit light Aloxaf/fzf-tab
### disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
### set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
### set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
### preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -hAFt --group-dirs first --color=always $realpath'
### switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# history
zinit ice wait
zinit snippet OMZP::dirhistory

# zinit ice wait 2
# zinit light zdharma-continuum/history-search-multi-word

# zinit ice wait
# zinit light tom-auger/cmdtime

## History search

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
