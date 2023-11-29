[ ! -d $ZINIT[HOME_DIR] ] && mkdir -p "$(dirname $ZINIT[HOME_DIR])"
[ ! -d $ZINIT[HOME_DIR]/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT[HOME_DIR]"

# Loading ZINIT
source "$ZINIT[HOME_DIR]/zinit.zsh"

# Plugins for eval cache
export ZSH_SMARTCACHE_DISABLE=false
export ZSH_SMARTCACHE_DIR="$XDG_CACHE_HOME/zsh/smartcache"
# load QuarticCat/zsh-smartcache > mroth/evalcache
zinit load QuarticCat/zsh-smartcache

## evaluting some useful commands and aliases
# smartcache comp register-python-argcomplete pipx
smartcache eval thefuck --alias
smartcache eval direnv hook zsh

# Plugins for annex speedups
zinit light-mode for \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-bin-gem-node \
    NICHOLAS85/z-a-eval

# bitwarden auto export session
zinit ice wait lucid nocd
zinit light Game4Move78/zsh-bitwarden

zinit ice wait lucid nocd
zinit light jgogstad/passwordless-history

zinit ice wait lucid nocd
zinit light icatalina/zsh-navi-plugin

export ZSH_FAST_ALIAS_TIPS_EXCLUDES=".. l s sl ll cd.. pdw sduo fd locate"
export ZSH_FAST_ALIAS_TIPS_PREFIX="💡💡💡 $(tput bold)"
export ZSH_FAST_ALIAS_TIPS_SUFFIX="$(tput sgr0)"
zinit ice wait lucid nocd
zinit light decayofmind/zsh-fast-alias-tips

# check that you are not in docker or a server avoid in headless installs
if [ -z "$DISPLAY" ] && [ -z "$SSH_CLIENT" ]; then
    echo "Not in a gui server"
else
    zinit ice wait lucid nocd
    zinit light MichaelAquilina/zsh-auto-notify
fi

zinit light zsh-users/zsh-history-substring-search
zmodload zsh/terminfo
[ -n "${terminfo[kcuu1]}" ] && bindkey "${terminfo[kcuu1]}" history-substring-search-up
[ -n "${terminfo[kcud1]}" ] && bindkey "${terminfo[kcud1]}" history-substring-search-down
bindkey -M emacs '^U' history-substring-search-up

zinit ice wait lucid nocd
zinit snippet OMZP::dirhistory

zinit has'zoxide' wait lucid for \
    z-shell/zsh-zoxide

## FZF tab completion
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git || git ls-tree -r --name-only HEAD || rg --files --hidden --follow --glob '!.git' || find ."
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --border'
export FZF_CTRL_T_OPTS="--preview '(bat --style=numbers --color=always {} || cat {} || tree -NC {}) 2> /dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --exact"
export FZF_ALT_C_OPTS="--preview 'tree -NC {} | head -200'"
zinit ice wait lucid depth"1" blockf # atload"zicompinit; zicdreplay"
zinit light Aloxaf/fzf-tab
zinit wait lucid light-mode depth=1 for \
    pick="autopair.zsh" atload="autopair-init" hlissner/zsh-autopair \
    pick="async.zsh" mafredri/zsh-async

if [[ $(tput colors) == 256 ]]; then
    zinit ice depth=1 lucid nocd atload'!source $ZDOTDIR/p10k.zsh'
    zinit light romkatv/powerlevel10k
fi

# Modern Unix commands
# See https://github.com/ibraheemdev/modern-unix
zinit wait as"null" lucid from"gh-r" for \
    atload"alias ls='lsd -hAFlt --group-dirs first --color=always'; alias la='lsd -laFh'" sbin"**/lsd" lsd-rs/lsd \
    atload"alias cat='bat -p --wrap character'" cp"**/bat.1 -> $ZPFX/share/man/man1" mv"**/autocomplete/bat.zsh -> _bat" completions sbin"**/bat" @sharkdp/bat \
    cp"**/fd.1 -> $ZPFX/share/man/man1" completions sbin"**/fd" @sharkdp/fd \
    cp"**/hyperfine.1 -> $ZPFX/share/man/man1" completions sbin"**/hyperfine" @sharkdp/hyperfine \
    cp"**/doc/rg.1 -> $ZPFX/share/man/man1" completions sbin"**/rg" BurntSushi/ripgrep \
    atload"alias top=btm" completions sbin"**/btm" ClementTsang/bottom \
    atload"alias help=tldr" mv"tealdeer* -> tldr" dl'https://github.com/dbrgn/tealdeer/releases/latest/download/completions_zsh -> _tldr;' completions sbin"tldr" dbrgn/tealdeer \
    atload"alias du=dust" sbin"**/dust" bootandy/dust \
    atload"alias diff=delta" completions sbin"**/delta" dandavison/delta

# HIGHLIGHT useful after grep
zinit ice pick"h.sh"
zinit light paoloantinori/hhighlighter

# Syntax highlight must be the last one
# import dracula theme
source "$ZDOTDIR/themes/dracula-theme.zsh"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1"
zinit wait lucid light-mode for \
    atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions
