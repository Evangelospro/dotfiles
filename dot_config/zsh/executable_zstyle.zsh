# Debugging
zstyle ':completion:*' verbose yes
zstyle ':completion:*' debug yes

# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
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

zstyle ':completion:*' completer _expand_alias _extensions _complete _approximate
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

# Fzf tab complete
# zstyle ':fzf-tab:*' switch-group '<' '>'
# zstyle ':fzf-tab:*' continuous-trigger ''
# zstyle ':fzf-tab:complete:(cd|ls|cat|nano|vi|vim|__zoxide_z):*' fzf-preview 'lsd -1 $realpath'
# zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
# 	fzf-preview 'echo ${(P)word}'
## Preview `kill` and `ps` commands
# zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
#         '[[ $group == "[process ID]" ]] &&
#             if [[ $OSTYPE == darwin* ]]; then
#             ps -p $word -o comm="" -w -w
#             elif [[ $OSTYPE == linux* ]]; then
#             ps --pid=$word -o cmd --no-headers -w -w
#             fi'
# zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
## Preview `git` commands
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
	'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
	'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
	'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta ;;
	esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
	esac'

# docker
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
