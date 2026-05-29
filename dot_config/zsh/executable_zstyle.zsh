# Debugging
# zstyle ':completion:*' verbose yes
# zstyle ':completion:*' debug yes

# Speed up completions
zstyle ':completion:*' accept-exact yes
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' rehash true

# zstyle ':completion:*' menu select interactive
zstyle ':completion:*' menu no

# Insert common substring first
## all Tab widgets
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
## all history widgets
zstyle ':autocomplete:*history*:*' insert-unambiguous yes
## ^S
zstyle ':autocomplete:menu-search:*' insert-unambiguous yes

zstyle ':autocomplete:*' recent-dirs zoxide
zstyle ':autocomplete:*' fzf-completion yes
zstyle ':autocomplete:*' widget-style menu-select
zstyle ':autocomplete:*' add-space '' # never add space after completion

zstyle -e ':completion:*' completer '
	if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]]; then
		_last_try="$HISTNO$BUFFER$CURSOR"
		reply=(_extensions _complete _prefix)
	else
		reply=(_ignored _correct _approximate)
	fi'
zstyle ':completion:*:paths' path-completion yes
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:complete:*:options' sort false
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# docker
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
